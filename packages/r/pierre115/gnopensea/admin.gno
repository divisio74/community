package gnopensea

import (
	"chain/banker"
	"chain/runtime"
)

// ============= ADMIN =============

func SetMarketplaceFee(newFee int64) {

    if runtime.OriginCaller() != admin {
        panic("Only admin can modify fees")
    }

    if newFee < 0 || newFee > 1000 { // Max 10%
        panic("Fees must be between 0% and 10%")
    }

    marketplaceFee = newFee
}

func WithdrawFees() {

    if runtime.OriginCaller() != admin {
        panic("Only admin can withdraw fees")
    }

    bnkr := banker.NewBanker(banker.BankerTypeRealmSend)
    realmAddr := runtime.CurrentRealm().Address()

    balance := bnkr.GetCoins(realmAddr)

    if balance.AmountOf("ugnot") > 0 {
        bnkr.SendCoins(realmAddr, admin, balance)
    }
}
