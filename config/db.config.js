'use strict';
const mysql = require('mysql');
require('dotenv').config();

//local mysql db connection
const connection = mysql.createConnection({
  host     : process.env.SELF_DATABASE_HOST,
  user     : process.env.SELF_DATABASE_USER,
  password : process.env.SELF_DATABASE_PASSWORD,
  database : process.env.SELF_DATABASE
});

connection.connect(function(err) {
  if (err) {
    console.error('error connecting: ' + err.stack);
    return;
  }
 
  console.log('connected as id ' + connection.threadId);
});

module.exports = connection;