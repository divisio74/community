# Configuration Réseau GnopenSea

## Réseau Actuel : **Staging**

### Paramètres RPC
- **RPC Endpoint** : `https://rpc.gno.land:443`
- **Chain ID** : `staging`
- **Network** : Staging

### Realms Déployés
- **Marketplace** : `gno.land/r/pierre115/gnopendao2`
- **Registry DAO** : `gno.land/r/pierre115/daoregistry4`

---

## Configuration du Wallet Adena

Pour utiliser l'application, vous devez configurer Adena pour pointer vers le réseau **Staging** :

### 1. Ouvrir Adena Wallet
Cliquez sur l'extension Adena dans votre navigateur

### 2. Ajouter le réseau Staging (si pas déjà fait)
- Cliquez sur le sélecteur de réseau (en haut)
- Sélectionnez **"Manage Networks"** ou **"Add Network"**
- Ajoutez les paramètres suivants :

```
Network Name: Gno Staging
RPC URL: https://rpc.gno.land:443
Chain ID: staging
```

### 3. Sélectionner le réseau
- Basculez vers le réseau **"Gno Staging"**
- Assurez-vous que le wallet est connecté à ce réseau avant d'interagir avec l'application

---

## Variables d'Environnement (Future)

Pour faciliter le changement de réseau, vous pouvez créer un fichier `.env.local` :

```env
NEXT_PUBLIC_RPC_ENDPOINT=https://rpc.gno.land:443
NEXT_PUBLIC_CHAIN_ID=staging
NEXT_PUBLIC_MARKETPLACE_REALM=gno.land/r/pierre115/gnopendao2
NEXT_PUBLIC_REGISTRY_REALM=gno.land/r/pierre115/daoregistry4
```

---

## Changer de Réseau

Pour passer à un autre réseau (ex: test4, mainnet), modifiez :
- [`src/lib/gno.ts`](src/lib/gno.ts) : Mettre à jour `provider` et les realms
- Configuration Adena : Basculer vers le réseau correspondant

---

## Réseaux Disponibles

| Réseau | RPC Endpoint | Chain ID | Status |
|--------|-------------|----------|--------|
| **Staging** | `https://rpc.gno.land:443` | `staging` | ✅ Actuel |
| Test9 | `https://rpc.test9.gno.land` | `test9` | ⚠️ Peut être arrêté |
| Test4 | `https://rpc.test4.gno.land` | `test4` | - |

---

## Vérification

Pour vérifier que tout fonctionne :

1. Ouvrez la console du navigateur (F12)
2. Vérifiez qu'il n'y a pas d'erreurs réseau
3. Les stats du marketplace devraient s'afficher (même à 0)
4. Pas d'erreur "Network Error" dans la console
