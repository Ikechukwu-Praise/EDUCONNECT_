const express = require('express');
const stripe = require('stripe')('sk_test_your_stripe_secret_key'); // Replace with your secret key
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

app.post('/api/create-payment-intent', async (req, res) => {
  try {
    const { amount, currency, userId, coins } = req.body;

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      metadata: {
        userId,
        coins: coins.toString()
      }
    });

    res.json({
      clientSecret: paymentIntent.client_secret
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.listen(3000, () => {
  console.log('Payment server running on port 3000');
});