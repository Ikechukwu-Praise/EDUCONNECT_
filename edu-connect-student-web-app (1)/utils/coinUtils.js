// utils/coinUtils.js
// Pricing model from plan: 20 coins = $7, 50 coins = $17, 100 coins = $33
export const PACKS = [
  { id: 'starter', coins: 20, price: 7.00 },
  { id: 'standard', coins: 50, price: 17.00 },
  { id: 'pro', coins: 100, price: 33.00 }
];

// Per-coin base value derived from the 20-coin pack
const BASE_PER_COIN = 7.00 / 20; // 0.35

export function getPriceForCoins(coins) {
  // If coins matches a pack, return the pack price (no rounding surprises)
  const pack = PACKS.find(p => p.coins === coins);
  if (pack) return pack.price;

  // Otherwise, use linear per-coin pricing derived from base pack
  return Number((coins * BASE_PER_COIN).toFixed(2));
}

export function formatPrice(amount) {
  return `$${Number(amount).toFixed(2)}`;
}

export function findPackByCoins(coins) {
  return PACKS.find(p => p.coins === coins) || null;
}
