'use client';

import { provider, MARKETPLACE_REALM, CHAIN_ID } from "@/lib/gno";

export default function ConfigPage() {
  // Afficher la config réelle
  const config = {
    rpcEndpoint: process.env.NEXT_PUBLIC_RPC_ENDPOINT || "NON DEFINI (fallback utilisé)",
    chainId: process.env.NEXT_PUBLIC_CHAIN_ID || "NON DEFINI (fallback utilisé)",
    marketplace: process.env.NEXT_PUBLIC_MARKETPLACE_REALM || "NON DEFINI (fallback utilisé)",
    registry: process.env.NEXT_PUBLIC_REGISTRY_REALM || "NON DEFINI (fallback utilisé)",
  };

  return (
    <div className="container mx-auto px-4 py-20">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-4xl font-bold mb-8 text-white">🔧 Configuration Frontend</h1>

        <div className="bg-secondary p-8 rounded-lg border border-border">
          <h2 className="text-2xl font-semibold mb-4 text-purple-400">Variables d'environnement</h2>

          <div className="space-y-4 font-mono text-sm">
            <div>
              <div className="text-gray-400">NEXT_PUBLIC_RPC_ENDPOINT:</div>
              <div className="text-green-400 break-all">{config.rpcEndpoint}</div>
            </div>

            <div>
              <div className="text-gray-400">NEXT_PUBLIC_CHAIN_ID:</div>
              <div className="text-green-400">{config.chainId}</div>
            </div>

            <div>
              <div className="text-gray-400">NEXT_PUBLIC_MARKETPLACE_REALM:</div>
              <div className="text-green-400">{config.marketplace}</div>
            </div>

            <div>
              <div className="text-gray-400">NEXT_PUBLIC_REGISTRY_REALM:</div>
              <div className="text-green-400">{config.registry}</div>
            </div>
          </div>

          <div className="mt-8 p-4 bg-yellow-900/20 border border-yellow-500 rounded">
            <p className="text-yellow-300 font-semibold">⚠️ Note:</p>
            <p className="text-sm text-gray-300 mt-2">
              Ces valeurs sont compilées au moment du build. Si vous modifiez `.env.local`,
              vous DEVEZ redémarrer le serveur Next.js (Ctrl+C puis `npm run dev`).
            </p>
          </div>

          <div className="mt-8">
            <h3 className="text-xl font-semibold mb-4 text-cyan-400">Test de connexion</h3>
            <button
              onClick={async () => {
                try {
                  const response = await provider.evaluateExpression(MARKETPLACE_REALM, "GetMarketplaceFee()");
                  alert(`✅ Connexion réussie!\nMarketplace Fee: ${response}`);
                } catch (error: any) {
                  alert(`❌ Erreur de connexion:\n${error.message}`);
                }
              }}
              className="px-6 py-3 bg-purple-500 hover:bg-purple-600 rounded-lg font-semibold"
            >
              Tester la connexion au marketplace
            </button>
          </div>
        </div>

        <div className="mt-8 p-6 bg-blue-900/20 border border-blue-500 rounded">
          <h3 className="text-xl font-semibold mb-2 text-blue-300">💡 Problème de connexion ?</h3>
          <ul className="text-sm text-gray-300 space-y-2 list-disc list-inside">
            <li>Vérifiez que le fichier `.env.local` existe dans `gnopensea-frontend/`</li>
            <li>Redémarrez le serveur Next.js après avoir modifié `.env.local`</li>
            <li>Si "NON DEFINI", le fichier n'est pas chargé correctement</li>
            <li>Les variables DOIVENT commencer par `NEXT_PUBLIC_` pour être accessibles côté client</li>
          </ul>
        </div>
      </div>
    </div>
  );
}
