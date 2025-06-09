/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");    

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')('pk_test_51RWu6CRtj3vJEaAcFBZqOMqk1Yk5npH4kBNQHYLKNpaUkmEd1ilMHnZehb02KYtQDE3CbCD7EgTtopvLKomYA4no008ImGeQJQ'); 

admin.initializeApp();

exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  const { amount, currency } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.status(200).send({
      clientSecret: paymentIntent.client_secret,
    });
  } catch (error) {
    res.status(400).send({ error: error.message });
  }
});

//firebase.json
// ,
      // "predeploy": [
      //   "npm --prefix \"$RESOURCE_DIR\" run lint"
      // ]

      

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
