var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  return res.send("Welcome to padzilla !!!");
});

var subscriptionRoutes = require('./subscriptionRoutes');
router.use('/subscription', subscriptionRoutes);

module.exports = router;
