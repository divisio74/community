# Gnoland NFT Marketplace

A fully-featured NFT marketplace for Gnoland blockchain with automatic royalty distribution (GRC-2981 compliant).

## Features

- GRC-721 compatible - works with any NFT collection implementing the standard
- Automatic royalties - supports GRC-2981 with automatic distribution
- Fixed price listings for immediate purchase
- Secure atomic transfers
- Configurable marketplace fees (default 2.5%)
- Complete on-chain sales history
- Volume and royalty statistics

## Architecture

```
Marketplace Realm
├── Listings (Active)
├── Sales (History)
└── Payment Distribution
    ├── Seller
    ├── Royalty (if GRC-2981)
    └── Marketplace Fee

NFT Collection (GRC-721)
├── OwnerOf()
├── TransferFrom()
├── Approve() / SetApprovalForAll()
└── RoyaltyInfo() (optional)
```

## Usage

### For Sellers

#### Step 1: Approve the Marketplace

```bash
# Approve for all NFTs (recommended)
gnokey maketx call \
  -pkgpath "gno.land/r/[username]/MYNFT" \
  -func "SetApprovalForAll" \
  -args "g1marketplace_address" \
  -args "true" \
  -broadcast \
  yourkey

# Or approve for a specific NFT
gnokey maketx call \
  -pkgpath "gno.land/r/[username]/MYNFT" \
  -func "Approve" \
  -args "g1marketplace_address" \
  -args "1" \
  -broadcast \
  yourkey
```

#### Step 2: Create a Listing


//todo

