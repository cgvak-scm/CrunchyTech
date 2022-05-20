var passport = require('passport');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const cert = fs.readFileSync(process.env.SELF_PUBLIC_KEY_PATH);
const moment = require('moment');
 
module.exports = {
  initialize: function(){
    return passport.initialize();
  },

  authenticate: function(req, res, next){
    const bearerHeader = req.headers['authorization']

    if (typeof bearerHeader !== 'undefined') {
      const bearer = bearerHeader.split(' ');
      const bearerToken = bearer[1];

      jwt.verify(bearerToken, cert, function(err) {
        if (err) {
          let msg = err.message.replace("jwt", "token").charAt(0).toUpperCase() + err.message.slice(1);
          console.log(msg)
          return res.status(401).json({message: msg});
        }
        else {
          next();
        }
      });
    } else {
      return res.status(401).json({message: "No auth token"});
    }
  }
}
