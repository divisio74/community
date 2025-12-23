# GnopenSea Frontend

Frontend Next.js pour le marketplace NFT décentralisé GnopenSea sur Gno.land.

## 🚀 Démarrage Rapide

### 1. Installation

```bash
npm install
```

### 2. Configuration du Réseau

Le frontend est configuré pour le réseau **Staging** de Gno.land.

**Paramètres actuels** (voir [`src/lib/gno.ts`](src/lib/gno.ts)) :
- RPC : `https://rpc.gno.land:443`
- Chain ID : `staging`
- Marketplace : `gno.land/r/pierre115/gnopendao2`
- Registry : `gno.land/r/pierre115/daoregistry4`

### 3. Configuration d'Adena Wallet

Pour interagir avec l'application, configurez [Adena Wallet](https://adena.app/) :

1. Installer l'extension Adena
2. Ajouter le réseau **Staging** :
   - Network Name : `Gno Staging`
   - RPC URL : `https://rpc.gno.land:443`
   - Chain ID : `staging`
3. Basculer vers ce réseau dans Adena

### 4. Lancer le Serveur de Développement

```bash
npm run dev
```

Ouvrez [http://localhost:3000](http://localhost:3000) pour voir l'application.

---

## 📁 Structure du Projet

```
src/
├── app/
│   ├── page.tsx              # Page d'accueil avec listings NFT
│   ├── layout.tsx            # Layout principal
│   └── globals.css           # Styles globaux (effets holographiques)
├── components/
│   ├── Header.tsx            # En-tête avec wallet connect
│   └── nft/
│       └── NFTCard.tsx       # Carte NFT
├── lib/
│   ├── gno.ts               # Configuration RPC et realms
│   ├── realm-calls.ts       # Appels aux smart contracts
│   └── types.ts             # Types TypeScript
└── hooks/
    └── useWallet.ts         # Hook pour Adena wallet
```

---

## 🔧 Configuration

### Changer de Réseau

Pour basculer vers un autre réseau (test4, mainnet, etc.), modifiez [`src/lib/gno.ts`](src/lib/gno.ts) :

```typescript
export const provider = new GnoJSONRPCProvider(
  "https://rpc.VOTRE_RESEAU.gno.land"
);

export const CHAIN_ID = "VOTRE_CHAIN_ID";
export const MARKETPLACE_REALM = "gno.land/r/VOTRE_USERNAME/VOTRE_REALM";
```

Voir [NETWORK_CONFIG.md](NETWORK_CONFIG.md) pour plus de détails.

---

## 🎨 Fonctionnalités

- ✅ Affichage des NFTs listés sur le marketplace
- ✅ Statistiques en temps réel (listings actifs, volume, ventes)
- ✅ Interface avec effets holographiques et animations
- ✅ Connexion wallet Adena
- ✅ Achat de NFTs
- ✅ Système de gouvernance DAO

---

## 🛠️ Technologies

- **Next.js 16** - Framework React
- **TypeScript** - Typage statique
- **Tailwind CSS v4** - Styling
- **TanStack Query** - Gestion des requêtes
- **@gnolang/gno-js-client** - Client RPC Gno.land
- **Adena Wallet** - Wallet Gno.land

---

## 📝 Scripts Disponibles

```bash
# Développement
npm run dev

# Build de production
npm run build

# Lancer en production
npm start

# Linter
npm run lint
```

---

## 🔍 Dépannage

### "Network Error" dans la console

- Vérifiez que le réseau Staging est en ligne
- Vérifiez votre connexion internet
- Consultez [https://rpc.gno.land:443](https://rpc.gno.land:443)

### Pas de données affichées

- Le marketplace peut être vide (aucun NFT listé)
- Vérifiez les realms dans [`src/lib/gno.ts`](src/lib/gno.ts)
- Ouvrez la console pour voir les erreurs

### Wallet ne se connecte pas

- Vérifiez qu'Adena est installé
- Vérifiez qu'Adena est sur le réseau `staging`
- Rechargez la page

---

## 📚 Documentation Complète

- [Configuration Réseau](NETWORK_CONFIG.md)
- [Smart Contracts (Backend)](../community/packages/r/pierre115/gnopendao/README.md)

---

## 🤝 Contribution

Ce projet fait partie du stage GnopenSea - Marketplace NFT décentralisé avec gouvernance DAO.

---

## 📄 License

Projet de stage - Tous droits réservés
