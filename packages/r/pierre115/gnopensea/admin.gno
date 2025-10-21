package gnopensea

import (
	"chain/banker"
	"chain/runtime"
)

// ============= ADMIN =============

func SetMarketplaceFee(newFee int64) {
	caller := runtime.PreviousRealm().Address()
	if caller != admin {
		panic("Only admin can modify fees")
	}

	if newFee < 0 || newFee > 1000 { // Max 10%
		panic("Fees must be between 0% and 10%")
	}

	marketplaceFee = newFee
}

func WithdrawFees() {
	caller := runtime.PreviousRealm().Address()
	if caller != admin {
		panic("Only admin can withdraw fees")
	}

	// Use NewBanker instead of GetBanker
	bnkr := banker.NewBanker(banker.BankerTypeRealmSend)
	realmAddr := runtime.CurrentRealm().Address()

	// Get balance of the realm
	balance := bnkr.GetCoins(realmAddr)

	if balance.AmountOf("ugnot") > 0 {
		bnkr.SendCoins(realmAddr, admin, balance)
	}
}
