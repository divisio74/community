package gnopensea

import (
	"chain/banker"
	"chain/runtime"
	"strconv"

	"gno.land/p/demo/tokens/grc721"
	"gno.land/p/nt/ufmt"
)

// ============= READ FUNCTIONS =============

func GetListing(listingId int) (int, string, int64, string, bool, int64) {
	listing := getListing(listingId)
	if listing == nil {
		return 0, "", 0, "", false, 0
	}

	return listing.ListingId,
		listing.TokenId.String(),
		listing.Price,
		listing.Seller.String(),
		listing.Active,
		listing.ListedAt
}

func GetSale(saleId int) (int, string, string, string, int64, int64, int64, string, int64) {
	value, exists := sales.Get(strconv.Itoa(saleId))
	if !exists {
		return 0, "", "", "", 0, 0, 0, "", 0
	}

	sale := value.(*Sale)
	return sale.ListingId,
		sale.TokenId,
		sale.Buyer.String(),
		sale.Seller.String(),
		sale.Price,
		sale.MarketplaceFee,
		sale.RoyaltyFee,
		sale.RoyaltyReceiver.String(),
		sale.SoldAt
}

func GetActiveListingsCount() int {
	count := 0
	listings.Iterate("", "", func(key string, value interface{}) bool {
		listing := value.(*Listing)
		if listing.Active {
			count++
		}
		return false
	})
	return count
}

func GetTotalSales() int {
	return sales.Size()
}

func GetTotalVolume() int64 {
	var total int64 = 0
	sales.Iterate("", "", func(key string, value interface{}) bool {
		sale := value.(*Sale)
		total += sale.Price
		return false
	})
	return total
}

func GetTotalRoyaltiesPaid() int64 {
	var total int64 = 0
	sales.Iterate("", "", func(key string, value interface{}) bool {
		sale := value.(*Sale)
		total += sale.RoyaltyFee
		return false
	})
	return total
}

func GetMarketplaceFee() int64 {
	return marketplaceFee
}

func GetMarketplaceAddress() address {
	return runtime.CurrentRealm().Address()
}

// GetRoyaltyBreakdown - Calculate distribution for a listing
func GetRoyaltyBreakdown(listingId int) (int64, int64, int64, address) {
	listing := getListing(listingId)
	if listing == nil {
		return 0, 0, 0, ""
	}

	// Calculate marketplace fee
	marketplaceFeeAmount := (listing.Price * marketplaceFee) / 10000

	// Calculate royalties if supported
	nftInstance := listing.NFTGetter()
	var royaltyAmount int64 = 0
	var royaltyReceiver address

	if royaltyNFT, ok := nftInstance.(grc721.IGRC2981); ok {
		addr, amount, err := royaltyNFT.RoyaltyInfo(listing.TokenId, listing.Price)
		if err == nil {
			royaltyAmount = amount
			royaltyReceiver = addr
		}
	}

	sellerAmount := listing.Price - marketplaceFeeAmount - royaltyAmount

	return sellerAmount, marketplaceFeeAmount, royaltyAmount, royaltyReceiver
}

func GetBalance() int64 {
	bnkr := banker.NewBanker(banker.BankerTypeRealmSend)
	realmAddr := runtime.CurrentRealm().Address()
	balance := bnkr.GetCoins(realmAddr)
	return balance.AmountOf("ugnot")
}

// ============= HELPERS =============

func getListing(listingId int) *Listing {
	value, exists := listings.Get(strconv.Itoa(listingId))
	if !exists {
		return nil
	}
	return value.(*Listing)
}

func formatPrice(ugnot int64) string {
	gnot := float64(ugnot) / 1000000.0
	return ufmt.Sprintf("%.2f GNOT", gnot)
}

func formatFee(basisPoints int64) string {
	percent := float64(basisPoints) / 100.0
	return ufmt.Sprintf("%.2f%%", percent)
}

func formatPercentage(value, total int64) string {
	if total == 0 {
		return "0%"
	}
	percent := (float64(value) / float64(total)) * 100.0
	return ufmt.Sprintf("%.1f%%", percent)
}
