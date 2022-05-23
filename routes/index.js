const express = require('express');
const router = express.Router();
const swaggerUi = require('swagger-ui-express');
const YAML = require('yamljs');
const swaggerDocument = YAML.load(`${process.env.SELF_ROOT_FOLDER_PATH}swagger.yaml`);

/* GET home page. */
router.get('/', function(req, res) {
  return res.send("Welcome to padzilla !!!");
});

const subscriptionRoutes = require('./subscriptionRoutes');
router.use('/subscription', subscriptionRoutes);

router.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

module.exports = router;
