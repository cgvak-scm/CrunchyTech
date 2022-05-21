var passport = require('passport');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const cert = fs.readFileSync(process.env.SELF_PUBLIC_KEY_PATH);
 
module.exports = {
  initialize: function(){
    return passport.initialize();
  },

  authenticate: function(req, res, next){
    const bearerHeader = req.headers['authorization']

    if (typeof bearerHeader !== 'undefined') {
      const bearer = bearerHeader.split(' ');
      const bearerToken = bearer[1];

      // Verify token authenticity using jwt.verify() method
      // Allow API calls if authentic JWT is present, else 401 error returned as response
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
      // 401 error returned as response if no JWT provided
      return res.status(401).json({message: "No auth token"});
    }
  }
}
