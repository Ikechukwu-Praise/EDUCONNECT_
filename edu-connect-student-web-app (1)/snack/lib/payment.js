// snack/lib/payment.js
// Payment integration placeholder for Flutterwave and Google Pay (MVP).
// Replace placeholders with production SDK keys and test properly before launching.

const FLUTTERWAVE_PUBLIC_KEY = 'YOUR_FLUTTERWAVE_PUBLIC_KEY'; // Get from Flutterwave dashboard
const FLUTTERWAVE_SECRET_KEY = 'YOUR_FLUTTERWAVE_SECRET_KEY'; // Backend only

// Placeholder: Simulate Flutterwave payment
export async function initiateFlutterwavePayment({ email, coins, amount }) {
  console.log('Flutterwave payment initiated (placeholder)', { email, coins, amount });
  // In production: use Flutterwave Web SDK or API
  // Example: https://developer.flutterwave.com/docs
  return { success: true, ref: `FLW_TEST_${Date.now()}` };
}

// Placeholder: Simulate Google Pay payment
export async function initiateGooglePayPayment({ coins, amount }) {
  console.log('Google Pay payment initiated (placeholder)', { coins, amount });
  // In production: use Google Pay API for web
  // Example: https://developers.google.com/pay/api/web/overview
  return { success: true, token: `GPay_TEST_${Date.now()}` };
}

// Helper to verify payment and update user coins
export async function verifyAndUpdateCoins(supabase, userId, coins, paymentRef) {
  try {
    // Fetch current profile coins
    const { data: profile, error: fetchErr } = await supabase
      .from('profiles')
      .select('coins')
      .eq('id', userId)
      .single();

    if (fetchErr) throw fetchErr;

    const newCoins = (profile?.coins || 0) + coins;

    // Update profile coins
    const { error: updateErr } = await supabase
      .from('profiles')
      .update({ coins: newCoins })
      .eq('id', userId);

    if (updateErr) throw updateErr;

    console.log(`Payment verified. User ${userId} now has ${newCoins} coins.`);
    return { success: true, newCoins };
  } catch (err) {
    console.error('Coin update failed:', err.message);
    return { success: false, error: err.message };
  }
}
