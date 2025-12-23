import { GnoJSONRPCProvider } from "@gnolang/gno-js-client";

// Configuration du provider - Use environment variables with fallback
const RPC_ENDPOINT = process.env.NEXT_PUBLIC_RPC_ENDPOINT || "https://rpc.gno.land:443";

export const provider = new GnoJSONRPCProvider(RPC_ENDPOINT);

// Chain configuration
export const CHAIN_ID = process.env.NEXT_PUBLIC_CHAIN_ID || "staging";

// Tes realms - Use environment variables with fallback
export const MARKETPLACE_REALM = process.env.NEXT_PUBLIC_MARKETPLACE_REALM || "gno.land/r/pierre115/gnopendao8";
export const REGISTRY_REALM = process.env.NEXT_PUBLIC_REGISTRY_REALM || "gno.land/r/pierre115/daoregistry4";

// Log configuration at startup
console.log("🔧 Gno.land Configuration:");
console.log("  RPC_ENDPOINT:", RPC_ENDPOINT);
console.log("  CHAIN_ID:", CHAIN_ID);
console.log("  MARKETPLACE_REALM:", MARKETPLACE_REALM);
console.log("  REGISTRY_REALM:", REGISTRY_REALM);

// Helper pour parser les réponses
export function parseRealmResponse(response: string) {
  try {
    // Les réponses Gno.land peuvent être dans différents formats:
    // Format 1: "data"
    // Format 2: ("data" string)
    // Format 3: (123 int) ou (0 int64)
    // Format 4: data

    let cleaned = response;

    // Format numérique: (123 int) ou (0 int64) → 123
    const numMatch = cleaned.match(/^\((\d+)\s+(int|int64|uint64)\)$/);
    if (numMatch) {
      return numMatch[1];
    }

    // Supprimer le format debug Gno.land: (" ... " string)
    cleaned = cleaned.replace(/^\("\s*/, '');  // Supprimer (" au début
    cleaned = cleaned.replace(/\s*"\s*string\)\s*$/, '');  // Supprimer " string) à la fin

    // Supprimer les quotes simples au début/fin
    cleaned = cleaned.replace(/^"|"$/g, '');

    // Remplacer les \n par de vrais retours à la ligne
    cleaned = cleaned.replace(/\\n/g, '\n');

    return cleaned;
  } catch (e) {
    console.error("Failed to parse realm response:", e);
    return "";
  }
}