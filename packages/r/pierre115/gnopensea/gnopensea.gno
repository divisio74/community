package gnopensea

import (
	"strconv"

	"chain"
	"chain/banker"
	"chain/runtime"

	"gno.land/p/demo/tokens/grc721"
	"gno.land/p/nt/avl"
	"gno.land/p/nt/ufmt"
)

var (
	listings              avl.Tree
	sales                 avl.Tree
	registeredCollections avl.Tree // address -> NFTGetter a enelever aussi
	nextListingId         = 1
	nextSaleId            = 1

	// Marketplace fee: 2.5%
	marketplaceFee  = int64(250) // 250 basis points = 2.5%
	marketplaceAddr = runtime.CurrentRealm().Address()
	admin           = address("g1e7r5eglptfejknps3xv2kxv6pc8wvd3wwtw6tg")
)

// ============= PUBLIC FUNCTIONS =============

// CreateListing - List an NFT for sale (now accepts collection address)
func CreateListing(_ realm, nftRealmAddress address, tokenId grc721.TokenID, price int64) int {
	caller := runtime.PreviousRealm().Address()

	if price <= 0 || price > 99999999999 {
		panic("Price not valid")
	}

	// Get NFT instance from registered collections a chnager pour inclure le realm nftregistry en prod
	nftGetter, exists := registeredCollections.Get(nftRealmAddress.String())
	if !exists {
		panic("NFT collection not registered. The collection must call RegisterCollection() first.")
	}

	getter := nftGetter.(grc721.NFTGetter)
	nftInstance := getter()

	// Verify caller is the owner
	owner, err := nftInstance.OwnerOf(tokenId)
	if err != nil {
		panic("Token not found: " + err.Error())
	}

	if owner != caller {
		panic("You are not the owner of this NFT")
	}

	// Verify approvals
	marketplaceAddr := runtime.CurrentRealm().Address()
	approvedAddr, err := nftInstance.GetApproved(tokenId)
	isApprovedForToken := (err == nil && approvedAddr == marketplaceAddr)
	isApprovedForAll := nftInstance.IsApprovedForAll(owner, marketplaceAddr)

	if !isApprovedForToken && !isApprovedForAll {
		panic("You must first approve the marketplace.\nUse Approve() or SetApprovalForAll()")
	}

	// Create listing
	listing := &Listing{
		ListingId: nextListingId,
		NFTGetter: getter,
		TokenId:   tokenId,
		Seller:    caller,
		Price:     price,
		Active:    true,
		ListedAt:  runtime.ChainHeight(),
	}

	listings.Set(strconv.Itoa(nextListingId), listing)
	nextListingId++

	return listing.ListingId
}

// BuyNFT - Purchase a listed NFT with automatic royalty calculation
func BuyNFT(_ realm, listingId int) {
	caller := runtime.PreviousRealm().Address()
	sent := banker.OriginSend()

	// Get listing
	listing := getListing(listingId)
	if listing == nil {
		panic("Listing not found")
	}

	if !listing.Active {
		panic("This listing is no longer active")
	}

	// Verify payment
	amount := sent.AmountOf("ugnot")
	if amount < listing.Price {
		panic(ufmt.Sprintf("Insufficient amount. Price: %d ugnot", listing.Price))
	}

	// Get NFT instance
	nftInstance := listing.NFTGetter()

	// Verify seller still owns the NFT
	currentOwner, err := nftInstance.OwnerOf(listing.TokenId)
	if err != nil {
		panic("NFT not found: " + err.Error())
	}
	if currentOwner != listing.Seller {
		panic("Seller no longer owns this NFT")
	}

	// Calculate royalties (if NFT supports GRC-2981)
	var royaltyAmount int64 = 0
	var royaltyReceiver address

	// Check if NFT supports royalties
	if royaltyNFT, ok := nftInstance.(grc721.IGRC2981); ok {
		addr, amount, err := royaltyNFT.RoyaltyInfo(listing.TokenId, listing.Price)
		if err == nil {
			royaltyAmount = amount
			royaltyReceiver = addr
		}
	}

	// Calculate marketplace fee
	marketplaceFeeAmount := (listing.Price * marketplaceFee) / 10000

	// Calculate what seller receives
	sellerAmount := listing.Price - marketplaceFeeAmount - royaltyAmount

	if sellerAmount < 0 {
		panic("Error: fees + royalties exceed sale price")
	}

	// Distribute payments
	bnkr := banker.NewBanker(banker.BankerTypeRealmSend)
	realmAddr := runtime.CurrentRealm().Address()

	// 1. Pay seller
	if sellerAmount > 0 {
		sellerCoins := chain.Coins{chain.Coin{"ugnot", sellerAmount}}
		bnkr.SendCoins(realmAddr, listing.Seller, sellerCoins)
	}

	// 2. Pay royalties to creator
	if royaltyAmount > 0 && royaltyReceiver != "" {
		royaltyCoins := chain.Coins{chain.Coin{"ugnot", royaltyAmount}}
		bnkr.SendCoins(realmAddr, royaltyReceiver, royaltyCoins)
	}

	// 3. Marketplace fees remain in contract (withdrawal by admin)

	// 4. Refund excess
	if amount > listing.Price {
		excess := amount - listing.Price
		excessCoins := chain.Coins{chain.Coin{"ugnot", excess}}
		bnkr.SendCoins(realmAddr, caller, excessCoins)
	}

	// Transfer NFT
	err = nftInstance.TransferFrom(listing.Seller, caller, listing.TokenId)
	if err != nil {
		panic("Transfer error: " + err.Error())
	}

	// Record sale
	sale := &Sale{
		ListingId:       listingId,
		TokenId:         listing.TokenId.String(),
		Buyer:           caller,
		Seller:          listing.Seller,
		Price:           listing.Price,
		MarketplaceFee:  marketplaceFeeAmount,
		RoyaltyFee:      royaltyAmount,
		RoyaltyReceiver: royaltyReceiver,
		SoldAt:          runtime.ChainHeight(),
	}

	sales.Set(strconv.Itoa(nextSaleId), sale)
	nextSaleId++

	// Deactivate listing
	listing.Active = false
	listings.Set(strconv.Itoa(listingId), listing)
}

// CancelListing - Cancel a listing
func CancelListing(_realm, listingId int) {
	caller := runtime.PreviousRealm().Address()

	listing := getListing(listingId)
	if listing == nil {
		panic("Listing not found")
	}

	if listing.Seller != caller {
		panic("Only the seller can cancel this listing")
	}

	if !listing.Active {
		panic("This listing is already inactive")
	}

	listing.Active = false
	listings.Set(strconv.Itoa(listingId), listing)
}

// UpdatePrice - Update listing price
func UpdatePrice(_ realm, listingId int, newPrice int64) {
	caller := runtime.PreviousRealm().Address()

	if newPrice <= 0 {
		panic("Price must be positive")
	}

	listing := getListing(listingId)
	if listing == nil {
		panic("Listing not found")
	}

	if listing.Seller != caller {
		panic("Only the seller can modify this listing")
	}

	if !listing.Active {
		panic("This listing is no longer active")
	}

	listing.Price = newPrice
	listings.Set(strconv.Itoa(listingId), listing)
}
