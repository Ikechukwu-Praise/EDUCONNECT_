// docs/PAYMENT_INTEGRATION.md
# EduConnect Payment Integration Guide

## Overview
This document covers integrating **Flutterwave** and **Google Pay** for coin purchases.

### Pricing Model
- 20 coins = $7.00
- 50 coins = $17.00
- 100 coins = $33.00

---

## 1. Flutterwave Integration (Web/Snack)

### Setup
1. Sign up at [Flutterwave Dashboard](https://dashboard.flutterwave.com)
2. Get your **Public Key** and **Secret Key**
3. Fill in `snack/lib/payment.js`:
   ```javascript
   const FLUTTERWAVE_PUBLIC_KEY = 'pk_test_...' // or pk_live_...
   const FLUTTERWAVE_SECRET_KEY = 'sk_test_...' // Backend only
   ```

### Web Payment Flow (HTML/JS)
- Use [Flutterwave Web SDK](https://developer.flutterwave.com/docs/integration-guides/web)
- Example in [payment.html](../payment.html): integrates Flutterwave as a payment method option

### Webhook Setup (Backend)
1. Go to Flutterwave Dashboard → Settings → Webhooks
2. Set webhook URL: `https://your-backend.com/webhooks/flutterwave`
3. Listen for `tx.completed` event

Example webhook handler (Node.js/Express):
```javascript
app.post('/webhooks/flutterwave', async (req, res) => {
  const { data } = req.body;
  const txRef = data.tx_ref; // reference from your client
  
  // Verify transaction with Flutterwave API
  const response = await fetch(`https://api.flutterwave.com/v3/transactions/${data.id}/verify`, {
    headers: { Authorization: `Bearer ${FLUTTERWAVE_SECRET_KEY}` }
  });
  const verified = await response.json();
  
  if (verified.data.status === 'successful') {
    // Update user coins in Supabase
    // Extract user ID from txRef and call verifyAndUpdateCoins()
    res.json({ status: 'success' });
  } else {
    res.json({ status: 'failed' });
  }
});
```

---

## 2. Google Pay Integration (Web)

### Setup
1. Follow [Google Pay Setup Guide](https://developers.google.com/pay/api/web/overview)
2. Register your website domain in Google Cloud Console
3. Create a Payment Gateway configuration

### Web Payment Flow
```javascript
const paymentRequest = {
  apiVersion: 2,
  apiVersionMinor: 0,
  allowedPaymentMethods: [
    {
      type: 'CARD',
      parameters: { allowedCardNetworks: ['VISA', 'MASTERCARD'] }
    }
  ],
  merchantInfo: { merchantId: 'YOUR_MERCHANT_ID', merchantName: 'EduConnect' },
  transactionInfo: { totalPriceStatus: 'FINAL', totalPrice: '7.00', currencyCode: 'USD' }
};

const client = new google.payments.api.PaymentsClient({ environment: 'PRODUCTION' }); // or TEST
client.loadPaymentData(paymentRequest)
  .then(paymentData => {
    // Send paymentData.paymentMethodData.tokenizationData.token to backend
  })
  .catch(err => console.error('Payment failed:', err));
```

### Webhook Setup
Google Pay webhooks vary by payment processor (e.g., Stripe, Square). Configure your processor's webhook to:
1. Receive payment notification
2. Verify transaction status
3. Call `verifyAndUpdateCoins()` in Supabase

---

## 3. Testing

### Flutterwave Test Card
- Card: `5531 8866 5214 2950`
- CVV: Any 3 digits
- Expiry: Any future date
- PIN: `1234`

### Google Pay Test
- Use Google Pay sandbox environment
- Test cards: [Google Pay Test Cards](https://developers.google.com/pay/api/android/guides/testing)

---

## 4. Production Checklist
- [ ] Replace test keys with live keys
- [ ] Enable HTTPS on all endpoints
- [ ] Configure CORS for your domain
- [ ] Test webhook signature verification
- [ ] Set up payment logging/analytics
- [ ] Create user-facing receipts/confirmations
- [ ] Load test your payment endpoints

---

## 5. Example: Complete Payment Flow

### Client Side (Snack/Web)
```javascript
// User selects 50 coins ($17)
const coins = 50, amount = 17.00;

// Call payment service
const result = await initiateFlutterwavePayment({ 
  email: userEmail, 
  coins, 
  amount 
});

if (result.success) {
  // Wait for webhook or poll backend for confirmation
  // Update UI: "Payment processing..."
}
```

### Server Side (Node.js/Supabase Edge Function)
```javascript
// Webhook receives payment confirmation from Flutterwave
// 1. Verify signature
// 2. Extract user ID and coins from transaction metadata
// 3. Call verifyAndUpdateCoins(supabase, userId, coins, paymentRef)
// 4. Return 200 OK to acknowledge webhook
```

### Database Update
- `profiles.coins` increments by purchased amount
- (Optional) Log transaction in a `transactions` table for audit trail

---

## 6. Notes
- All payment SDKs require HTTPS in production.
- Test thoroughly in sandbox mode before going live.
- Handle network errors gracefully (retry logic recommended).
- For production, add transaction logging and dispute handling.
