const express = require('express');
const router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  return res.send("Welcome to padzilla !!!");
});

const subscriptionRoutes = require('./subscriptionRoutes');
router.use('/subscription', subscriptionRoutes);

module.exports = router;
