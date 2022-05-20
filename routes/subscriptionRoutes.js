const express = require('express');
const router = express.Router();
const subscriptionController = require('../controllers/subscriptionController');
const passportManager = require('../helpers/passport');

router.get('/sync/start', passportManager.authenticate, subscriptionController.startSubscriptionSync);
router.get('/sync/stop', passportManager.authenticate, subscriptionController.stopSubscriptionSync);
router.get('/:zohoSubscriptionId', passportManager.authenticate, subscriptionController.getSubscription);
router.get('/:zohoSubscriptionId/renew', passportManager.authenticate, subscriptionController.renewZohoSubscription);
router.get('/:zohoSubscriptionId/verify', subscriptionController.verifyZohoSubscription);

module.exports = router;
