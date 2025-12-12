# GnopenSea - NFT Marketplace

Marketplace NFT décentralisé sur Gno.land avec gouvernance DAO.

## 🚀 Comment lister votre NFT en 3 étapes

### Étape 1 : Enregistrer votre collection

**Depuis votre package NFT**, appelez la fonction `Register()` :

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/[votre-username]/[votre-nft]" \
  -func "Register" \
  -gas-fee 1000000ugnot \
  -gas-wanted 5000000 \
  -broadcast \
  -chainid "staging" \
  votre-wallet
```

Cela enregistre votre collection dans le **Registry DAO** (statut: non vérifié).

### Étape 2 : Approuver le marketplace

Donnez la permission au marketplace de transférer vos NFTs :

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/[votre-username]/[votre-nft]" \
  -func "SetApprovalForAll" \
  -args "g1[adresse-du-marketplace]" \
  -args "true" \
  -gas-fee 1000000ugnot \
  -gas-wanted 5000000 \
  -broadcast \
  votre-wallet
```

### Étape 3 : Créer votre listing

Listez votre NFT à vendre :

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/gnopendao" \
  -func "CreateListing" \
  -args "gno.land/r/[votre-username]/[votre-nft]" \
  -args "1" \
  -args "5000000" \
  -gas-fee 1000000ugnot \
  -gas-wanted 5000000 \
  -broadcast \
  votre-wallet
```

**Paramètres :**
- 1er arg : Adresse de votre package NFT
- 2ème arg : Token ID à vendre
- 3ème arg : Prix en ugnot (5000000 = 5 GNOT)

---

## 🛒 Acheter un NFT

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/gnopendao" \
  -func "BuyNFT" \
  -args "1" \
  -send "5000000ugnot" \
  -gas-fee 1000000ugnot \
  -gas-wanted 5000000 \
  -broadcast \
  votre-wallet
```

---

## 📋 Gérer vos listings

### Modifier le prix

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/gnopendao" \
  -func "UpdatePrice" \
  -args "1" \
  -args "10000000" \
  -broadcast \
  votre-wallet
```

### Annuler un listing

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/gnopendao" \
  -func "CancelListing" \
  -args "1" \
  -broadcast \
  votre-wallet
```

---

## 🎨 Faire vérifier votre collection (badge vérifié)

### 1. Créer une proposal au Registry DAO

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/daoregistry4" \
  -func "ProposeVerifyCollection" \
  -args "g1[adresse-de-votre-nft]" \
  -args "Nom de la collection" \
  -args "Raison de la vérification" \
  -gas-fee 1000000ugnot \
  -gas-wanted 5000000 \
  -broadcast \
  votre-wallet
```

### 2. Les membres du DAO votent

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/daoregistry4" \
  -func "VoteRegistry" \
  -args "1" \
  -args "yes" \
  -broadcast \
  membre-dao-wallet
```

### 3. Exécuter la proposal (après quorum)

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/daoregistry4" \
  -func "TallyRegistryProposal" \
  -args "1" \
  -broadcast \
  votre-wallet
```

---

## 💰 Distribution des paiements

Exemple avec frais marketplace 2.5% et royalties 10% :

```
Prix de vente : 100 GNOT
├── Frais marketplace (2.5%) : 2.5 GNOT
├── Royalties créateur (10%) : 10 GNOT
└── Vendeur reçoit : 87.5 GNOT
```

---

## 🏛️ Gouvernance DAO

Le marketplace est gouverné par un DAO. Les membres peuvent créer des proposals pour :

- ✅ Approuver/retirer des collections
- ✅ Modifier les frais du marketplace
- ✅ Retirer des fonds du trésor
- ✅ Annuler un listing problématique

### Créer une proposal (exemple: modifier les frais)

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/gnopendao" \
  -func "ProposeUpdateFees" \
  -args "300" \
  -args "Réduction des frais à 3%" \
  -broadcast \
  membre-dao-wallet
```

### Voter sur une proposal

```bash
gnokey maketx call \
  -pkgpath "gno.land/r/pierre115/gnopendao" \
  -func "Vote" \
  -args "1" \
  -args "yes" \
  -broadcast \
  membre-dao-wallet
```

---

## 🔧 Configuration NFT minimale

Votre package NFT doit avoir une fonction `Register()` :

```go
package mynft

import (
    "gno.land/p/demo/tokens/grc721"
    "gno.land/r/pierre115/daoregistry4"
)

var (
    nft         *grc721.basicNFT
    myRealmAddr = runtime.CurrentRealm().Address()
)

func init() {
    nft = grc721.NewBasicNFT("My Collection", "MC")
}

// Register dans le registry
func Register(_ realm) {
    daoregistry4.RegisterCollection(
        myRealmAddr,
        "My Collection",
        "MC",
        "art",
        "Description de ma collection",
        "https://mon-site.com",
        false,
        nft.Getter(),
    )
}

// Fonction obligatoire pour le marketplace
func Getter() grc721.NFTGetter {
    return nft.Getter()
}
```

---

## 📊 Fonctions de lecture

```bash
# Voir tous les listings actifs
curl https://rpc.gno.land/r/pierre115/gnopendao:

# Statistiques du marketplace
curl https://rpc.gno.land/r/pierre115/gnopendao:stats

# Détails d'un listing
curl https://rpc.gno.land/r/pierre115/gnopendao:listing/1

# Collections enregistrées
curl https://rpc.gno.land/r/pierre115/daoregistry4:
```

---

## 🔐 Sécurité

- ✅ Vérification de propriété avant listing
- ✅ Vérification d'approbation avant vente
- ✅ Transferts atomiques
- ✅ Remboursement automatique des surplus
- ✅ Limites de frais (max 10%)
- ✅ Gouvernance décentralisée

---

## 🆘 Problèmes courants

**"Collection not registered"**
→ Vous devez d'abord appeler `Register()` sur votre NFT

**"Insufficient payment"**
→ Le montant envoyé doit correspondre au prix du listing

**"Not approved"**
→ Appelez `SetApprovalForAll()` avant de créer un listing

**"Not owner"**
→ Seul le propriétaire du NFT peut le lister
