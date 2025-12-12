package mynft

import (
	"chain/runtime"
	"strconv"

	"gno.land/p/demo/tokens/grc721"
	"gno.land/p/nt/ufmt"
	"gno.land/r/pierre115/registrydao"
)

type NFTCollection interface {
	grc721.IGRC721
	Mint(to address, tid grc721.TokenID) error
	Getter() grc721.NFTGetter
}

var (
	nft         NFTCollection
	nextTokenId = 1
	myRealmAddr = runtime.CurrentRealm().Address()
)

func init() {
	nft = grc721.NewBasicNFT("Test NFT Collection", "TEST")
}

// Register registers this collection on the NFT registry
func Register(_ realm) {
	registrydao.RegisterCollection(
		myRealmAddr,
		"Test NFT Collection",
		"TEST",
		"art",
		"First wars",
		"https://example.com",
		false,
		nft.Getter(),
	)
}

func MintNFT(_ realm) int {
	caller := runtime.PreviousRealm().Address()
	tokenId := grc721.TokenID(strconv.Itoa(nextTokenId))

	err := nft.Mint(caller, tokenId)
	if err != nil {
		panic(err.Error())
	}

	nextTokenId++
	return nextTokenId - 1
}

// SetApprovalForAll - Approve or revoke operator to manage all caller's NFTs: true/false
func SetApprovalForAll(_ realm, operator address, approved bool) {
	err := nft.SetApprovalForAll(operator, approved)
	if err != nil {
		panic(err.Error())
	}
}

func Getter() grc721.NFTGetter {
	return nft.Getter()
}

func Render(path string) string {
	output := "# My test collection\n\n"
	output += "## test\n\n"
	output += ufmt.Sprintf("**NftRealmAddr:** %d\n\n", myRealmAddr.String())
	return output
}
