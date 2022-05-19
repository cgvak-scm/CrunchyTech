var express = require('express');
var router = express.Router();
var subscriptionController = require('../controllers/subscriptionController.js');

router.get('/startSubscriptionSync', subscriptionController.startSubscriptionSync);
router.get('/stopSubscriptionSync', subscriptionController.stopSubscriptionSync);
router.get('/getSubscription/:zohoSubscriptionId', subscriptionController.getSubscription);
router.get('/renewZohoSubscription/:zohoSubscriptionId', subscriptionController.renewZohoSubscription);
router.get('/verifyZohoSubscription/:zohoSubscriptionId', subscriptionController.verifyZohoSubscription);

module.exports = router;
