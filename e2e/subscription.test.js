const mysql = require("mysql");
const connection = mysql.createConnection({
  host     : process.env.SELF_DATABASE_HOST,
  user     : process.env.SELF_DATABASE_USER,
  password : process.env.SELF_DATABASE_PASSWORD,
  database : process.env.SELF_DATABASE
});
const supertest = require('supertest');
const prompt = require('prompt-sync')();
require('dotenv').config();
const fs = require('fs');
const cert = fs.readFileSync(process.env.SELF_PUBLIC_KEY_PATH);
const jwt = require('jsonwebtoken');

const baseUrl = "http://localhost";
// Create a real time JWT with 1 hour expiry for Padzilla API calls in below test cases
let authToken = `Bearer ${jwt.sign({type: "Testing"}, cert, { expiresIn: '1h' })}`;
let zohoSubscriptionId = "";

// Run once before all test cases are executed
beforeAll(async () => {
  try {
    // Prompt user to provide Zoho subscription id for Padzilla API calls
    zohoSubscriptionId = await prompt('Please enter Zoho subscription_id: ');
    connection.connect(() => {
      console.log("DB connceted");
    });
  } catch (error) {
    console.log("Error getting user input: ", error);
  }
})

// Run once after all test cases are executed
afterAll((done) => {
	connection.end(() => {
    console.log("DB disconnceted");
    done();
  });
})

// Test case for API /subscription/sync/start
test(`GET /subscription/sync/start`, async () => {
	await supertest(baseUrl)
    .get(`/subscription/sync/start`)
    .set('Accept', 'application/json')
    .set('Authorization', authToken)
    .expect(200)
		.then((res) => {
      if (res.error) console.log(res.error);
		})
})

// Test case for API /subscription/sync/stop
test(`GET /subscription/sync/stop`, async () => {
	await supertest(baseUrl)
    .get(`/subscription/sync/stop`)
    .set('Accept', 'application/json')
    .set('Authorization', authToken)
    .expect(200)
		.then((res) => {
      if (res.error) console.log(res.error);
		})
})

// Test case for API /subscription/:zohoSubscriptionId
test(`GET /subscription/${zohoSubscriptionId}`, async () => {
	await supertest(baseUrl)
    .get(`/subscription/${zohoSubscriptionId}`)
    .set('Accept', 'application/json')
    .set('Authorization', authToken)
    .expect(200)
		.then((res) => {
      if (res.error) console.log(res.error);
		})
})

// Test case for API /subscription/:zohoSubscriptionId/renew
test(`GET /subscription/${zohoSubscriptionId}/renew`, async () => {
	await supertest(baseUrl)
    .get(`/subscription/${zohoSubscriptionId}/renew`)
    .set('Accept', 'application/json')
    .set('Authorization', authToken)
    .expect(200)
		.then((res) => {
      if (res.error) console.log(res.error);
		})
})

// Test case for API /subscription/:zohoSubscriptionId/verify
test(`GET /subscription/${zohoSubscriptionId}/verify`, async () => {
	await supertest(baseUrl)
    .get(`/subscription/${zohoSubscriptionId}/verify`)
    .set('Accept', 'application/json')
    .expect(200)
		.then((res) => {
      if (res.error) console.log(res.error);
		})
})