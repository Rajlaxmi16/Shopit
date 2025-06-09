const Stripe = require('stripe');
const stripe = Stripe(process.env.STRIPE_SECRET_KEY); // Secure key

exports.handler = async (event) => {
  const body = JSON.parse(event.body);
  const amount = body.amount;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount,
      currency: 'inr',
      payment_method_types: ['card'],
    });

    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*', // CORS support
      },
      body: JSON.stringify({ clientSecret: paymentIntent.client_secret }),
    };
  } catch (err) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: err.message }),
    };
  }
};
