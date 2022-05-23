const SubscriptionModel = require('../config/db.config');
const axios = require('axios').default;
const ZOHO = {
  client_id: process.env.SELF_ZOHO_CLIENT_ID,
  client_secret: process.env.SELF_ZOHO_SECRET,
  refresh_token: process.env.SELF_ZOHO_REFRESH_TOKEN,
  redirect_uri: process.env.SELF_ZOHO_REDIRECT_URI,
  organizationId: process.env.SELF_ZOHO_ORGANIZATION_ID,
  pollRate: process.env.SELF_ZOHO_POLL_RATE_SECONDS
};
const moment = require('moment');
const jwt = require('jsonwebtoken');
const fs = require('fs');
// Public key for JWT encrytion
const cert = fs.readFileSync(`${process.env.SELF_ROOT_FOLDER_PATH}public.pem`);

let syncInProgress = false;
let syncSubscription = null;
let accessTokenErrorRetry = 0;
let allSubscriptionsErrorRetry = 0;
let oneSubscriptionErrorRetry = 0;

// Zoho api call to generate access token from refresh token
async function generateAccessToken() {
  return await axios({
    method: 'post',
    url: "https://accounts.zoho.com/oauth/v2/token",
    params: {
      refresh_token: ZOHO.refresh_token,
      client_id: ZOHO.client_id,
      client_secret: ZOHO.client_secret,
      grant_type: "refresh_token",
      redirect_uri: ZOHO.redirect_uri
    }
  }).then(function (response) {
    let accessToken = response.data.access_token;
    return accessToken;
  })
  .catch(function (err) {
    console.log(`Error generating access token from Zoho: `, err.response.data);
    // If API fails, retry for maximum 3 times
    if (accessTokenErrorRetry < 3) {
      accessTokenErrorRetry += 1;
      console.log(`Retry ${accessTokenErrorRetry}, for generating new access token`);
      generateAccessToken();
    }
    else {
      accessTokenErrorRetry = 0;
      console.log("Maximum retries reached!");
      return false;
    }
  });
}

// Zoho api call to fetch single subscription using zohoSubscriptionId & accessToken
async function getOneSubscriptionFromZoho(zohoSubscriptionId, accessToken) {
  return await axios({
    method: 'get',
    url: `https://subscriptions.zoho.com/api/v1/subscriptions/${zohoSubscriptionId}`,
    headers: {
      "X-com-zoho-subscriptions-organizationid": ZOHO.organizationId,
      "Authorization": `Zoho-oauthtoken ${accessToken}`
    }
  }).then(function (response) {
    return response.data.subscription;
  })
  .catch(function (err) {
    console.log(`Error fetching one subscription from Zoho: `, err.response.data);
    if (err && err.response && err.response.data && err.response.data.code && err.response.data.code != 1002) {
      if (oneSubscriptionErrorRetry < 3) {
        oneSubscriptionErrorRetry += 1;
        console.log(`Retry ${oneSubscriptionErrorRetry}, with new access token`);
        getOneSubscriptionFromZoho(zohoSubscriptionId, accessToken);
      }
      else {
        oneSubscriptionErrorRetry = 0;
        console.log("Maximum retries reached!");
        return false;
      }
    }
    else {
      return false;
    }
  });
}

// Insert subscription to Db, if not present
async function insertSubscriptionToDb(zohoSubscription, subscriptionType) {
  try {
    SubscriptionModel.query(`INSERT INTO t_subscriptions 
      (id_zoho_subscription, f_id_subscription_type, id_customer_id, id_customer_name, id_status, id_next_billing_at,id_token_expires_at, id_last_pulled_date, id_last_issue_date, id_quantity, id_current_term_starts_at, id_activated_at)
      SELECT * FROM (SELECT '${zohoSubscription.subscription_id}' AS id_zoho_subscription, '${subscriptionType.id_type}' AS f_id_subscription_type, '${zohoSubscription.customer_id}' AS id_customer_id, '${zohoSubscription.customer_name}' AS id_customer_name, '${zohoSubscription.status}' AS id_status, '${moment(zohoSubscription.next_billing_at).endOf('day').format('YYYY-MM-DD hh:mm:ss')}' AS id_next_billing_at, null AS id_token_expires_at, '${moment().format('YYYY-MM-DD hh:mm:ss')}' AS id_last_pulled_date, null AS id_last_issue_date, '${zohoSubscription.plan.quantity}' AS id_quantity, '${moment(zohoSubscription.current_term_starts_at).endOf('day').format('YYYY-MM-DD hh:mm:ss')}' AS id_current_term_starts_at, '${moment(zohoSubscription.activated_at).endOf('day').format('YYYY-MM-DD hh:mm:ss')}' AS id_activated_at) AS tmp
      WHERE NOT EXISTS (
          SELECT id_zoho_subscription FROM t_subscriptions WHERE id_zoho_subscription = '${zohoSubscription.subscription_id}'
      ) LIMIT 1`, function (err, data) {
      if (err) {
        console.log(`Error inserting subscription into Db - ${zohoSubscription.subscription_id} : `, err);
      } else {
        console.log(`Successfully inserted subscription into Db - ${zohoSubscription.subscription_id} : `, data);
      }
    })
  } catch (error) {
    console.log(`Internal server error: `, error);
  }
}

// Update subscription to Db, if present
async function updateSubscriptionInDb(zohoSubscription, dbSubscription, subscriptionType) {
  try {
    SubscriptionModel.query(`UPDATE t_subscriptions SET id_zoho_subscription='${zohoSubscription.subscription_id}', 
    f_id_subscription_type='${subscriptionType.id_type}', id_customer_id='${zohoSubscription.customer_id}', id_customer_name='${zohoSubscription.customer_name}', id_status='${zohoSubscription.status}', id_next_billing_at='${moment(zohoSubscription.next_billing_at).endOf('day').format('YYYY-MM-DD hh:mm:ss')}', id_last_pulled_date='${moment().format('YYYY-MM-DD hh:mm:ss')}', id_quantity='${zohoSubscription.plan.quantity}', id_current_term_starts_at='${moment(zohoSubscription.current_term_starts_at).endOf('day').format('YYYY-MM-DD hh:mm:ss')}', id_activated_at='${moment(zohoSubscription.activated_at).endOf('day').format('YYYY-MM-DD hh:mm:ss')}' WHERE id_subscription = '${dbSubscription.id_subscription}'`, function (err, data) {
      if (err) {
        console.log(`Error updating subscription into Db - ${zohoSubscription.subscription_id} : `, err);
      } else {
        console.log(`Successfully updated subscription into Db - ${zohoSubscription.subscription_id} : `, data);
      }
    })
  } catch (error) {
    console.log(`Internal server error: `, error);
  }
}

// Find subscription from Db, if not present call insertSubscriptionToDb() to insert
// else call updateSubscriptionInDb() to update
async function findSubscriptionFromDb(zohoSubscription, subscriptionType) {
  try {
    SubscriptionModel.query(`SELECT * FROM t_subscriptions WHERE id_zoho_subscription = '${zohoSubscription.subscription_id}'`, function (err, data) {
      if (err) {
        console.log(`Error when finding subscription from Db - ${zohoSubscription.subscription_id} : `, err);
      }
      else {

        if (data.length) {
          let dbSubscription = data[0];
          updateSubscriptionInDb(zohoSubscription, dbSubscription, subscriptionType);
        }
        else {
          insertSubscriptionToDb(zohoSubscription, subscriptionType);
        }

      }
    })
  } catch (error) {
    console.log(`Internal server error: `, error);
  }
}

// Insert subscription type to Db, if not present
async function insertSubscriptionTypeToDb(subscription, accessToken, zohoSubscription) {
  try {
    SubscriptionModel.query(`INSERT INTO t_subscription_types (id_label) VALUES ('${zohoSubscription.plan.name}')`, function (err, data) {
      if (err) {
        console.log(`Error when inserting subscription type into Db - ${zohoSubscription.plan.name} : `, err);
      }
      else {
        findSubscriptionTypeFromDb(subscription, accessToken, zohoSubscription);
      }
    })
  } catch (error) {
    console.log(`Internal server error: `, error);
  }
}

// Find subscription type from Db, if not present call insertSubscriptionTypeToDb() to insert
// else call findSubscriptionFromDb() to check if incoming zoho subscription needs to insert or update
async function findSubscriptionTypeFromDb(subscription, accessToken, zohoSubscription) {
  if (!zohoSubscription) {
    let zohoSubscriptionId = subscription.subscription_id;
    zohoSubscription = await getOneSubscriptionFromZoho(zohoSubscriptionId, accessToken);
    findSubscriptionTypeFromDb(subscription, accessToken, zohoSubscription);
  }
  else {
    try {
      SubscriptionModel.query(`SELECT * FROM t_subscription_types WHERE id_label = '${zohoSubscription.plan.name}'`, function (err, data) {
        if (err) {
          console.log(`Error when finding subscription type into Db - ${zohoSubscription.plan.name} : `, err);
        }
        else {

          if (data.length) {
            let subscriptionType = data[0];
            findSubscriptionFromDb(zohoSubscription, subscriptionType);
          }
          else {
            insertSubscriptionTypeToDb(subscription, accessToken, zohoSubscription);
          }

        }
      })
    } catch (error) {
      console.log(`Internal server error: `, error);
    }
  }
}

// Zoho api call to fetch all subscriptions, page wise, using page number & accessToken
async function getAllSubscriptionsFromZoho(accessToken, page) {
  if (!accessToken) {
    accessToken = await generateAccessToken();
    getAllSubscriptionsFromZoho(accessToken, page);
  }
  else {
    axios({
      method: 'get',
      url: `https://subscriptions.zoho.com/api/v1/subscriptions?page=${page}`,
      headers: {
        "X-com-zoho-subscriptions-organizationid": ZOHO.organizationId,
        "Authorization": `Zoho-oauthtoken ${accessToken}`
      }
    }).then(function (response) {
      let subscriptions = response.data.subscriptions;
      let page = response.data.page_context.page;
      let hasMorePage = response.data.page_context.has_more_page
  
      // If subscriptions present, call findSubscriptionTypeFromDb() for each subscription
      // to find or insert subscription type thereby inserting subscription to DB with subscription type foreign key
      if (subscriptions.length) {
        function subscriptionsLoop(i, callback) {
          if (i < subscriptions.length) {
            let subscription = subscriptions[i];
            findSubscriptionTypeFromDb(subscription, accessToken, null);
            setTimeout(function() {
              subscriptionsLoop(i+1, callback);
            }, 2000)
          }
          else {
            callback();
          }
        }

        subscriptionsLoop(0, function() {
          // Once all subscriptions inserted into DB from one API call, check if next page present
          // if next page present, make API call with next page number
          if (hasMorePage) {
            page += 1;
            getAllSubscriptionsFromZoho(accessToken, page);
          }
        });
      }
    })
    .catch(function (err) {
      console.log(`Error fetching subscriptions from Zoho: `, err.response.data);
      if (allSubscriptionsErrorRetry < 3) {
        allSubscriptionsErrorRetry += 1;
        console.log(`Retry ${allSubscriptionsErrorRetry}, with new access token for page = ${page}`);
        getAllSubscriptionsFromZoho(false, page);
      }
      else {
        allSubscriptionsErrorRetry = 0;
        console.log("Maximum retries reached!");
      }
    });
  }

  // Start syncing with delay of ZOHO.pollRate seconds
  if (syncInProgress) {
    syncSubscription = setTimeout(() => {
      getAllSubscriptionsFromZoho(false, 1);
    }, ZOHO.pollRate * 1000);
  }
}

/**
 * subscriptionController.js
 *
 * @description :: Server-side logic for managing subscriptions.
 */
module.exports = {

  /**
   * zohoAuthController.startSubscriptionSync()
   */
   startSubscriptionSync: async function(req, res) {
    try {
      syncInProgress = true; // Enables syncing
      getAllSubscriptionsFromZoho(false, 1);
      res.status(200).json({message: "Sync started!"});
    } catch (error) {
      console.log(`Internal server error: `, error);
      res.status(500).json(error);
    }
  },

  /**
   * zohoAuthController.stopSubscriptionSync()
   */
  stopSubscriptionSync: function(req, res) {
    try {
      syncInProgress = false; // Stops future sync
      clearTimeout(syncSubscription); // Stops queued sync
      res.status(200).json({message: "Sync stopped!"});
    } catch (error) {
      console.log(`Internal server error: `, error);
      res.status(500).json(error);
    }
  },

  /**
   * zohoAuthController.getSubscription()
   */
  getSubscription: async function(req, res) {
    try {
      let zohoSubscriptionId = req.params.zohoSubscriptionId;

      // Join table query of t_subscriptions and t_subscription_types, 
      // to get subscription details with subscription type name
      // for JWT creation
      SubscriptionModel.query(`SELECT t_subscriptions.id_status AS id_status,
      t_subscriptions.id_activated_at AS id_activated_at,
      t_subscriptions.id_next_billing_at AS id_next_billing_at,
      t_subscriptions.id_current_term_starts_at AS id_current_term_starts_at,
      t_subscription_types.id_label AS subscription_type_id_label
      FROM t_subscriptions
      JOIN t_subscription_types
        ON t_subscriptions.f_id_subscription_type = t_subscription_types.id_type
      WHERE t_subscriptions.id_zoho_subscription='${zohoSubscriptionId}' LIMIT 1`, function (err, data) {
        if (err) {
          console.log(`Error when finding subscription from Db - ${zohoSubscriptionId} : `, err);
          res.status(500).json(err);
        } 
        else {
          if (data.length) {
            let dbSubscription = data[0];
            let tokenValidityDays = null;
            let differenceInDays = 0;

            // JWT token expiry calculated as follows :-
              // If status = "future", calculate days difference between now and id_activated_at
              // If status = "live", calculate days difference between now and id_next_billing_at
              // If status = "trial", calculate days difference between now and id_current_term_starts_at
              // If status = "anything_else", no expiry
            // Select minimun between 20 days and calculated days difference
            if (dbSubscription.id_status == "future") {
              differenceInDays = moment(dbSubscription.id_activated_at).diff(moment(), 'days') + 1;
              if (differenceInDays > 20) {
                tokenValidityDays = 20;
              }
              else {
                tokenValidityDays = differenceInDays;
              }
            }
            else if (dbSubscription.id_status == "live") {
              differenceInDays = moment(dbSubscription.id_next_billing_at).diff(moment(), 'days') + 1;
              if (differenceInDays > 20) {
                tokenValidityDays = 20;
              }
              else {
                tokenValidityDays = differenceInDays;
              }
            }
            else if (dbSubscription.id_status == "trial") {
              differenceInDays = moment(dbSubscription.id_current_term_starts_at).diff(moment(), 'days') + 1;
              if (differenceInDays > 20) {
                tokenValidityDays = 20;
              }
              else {
                tokenValidityDays = differenceInDays;
              }
            }
            else {
              tokenValidityDays = null; // set to null, if status != ['future','live','trial']
            }

            // minimum JWT payload, without expiration time
            let jwtPayload = {
              status: dbSubscription.id_status,
              subscriptionPlanLabel: dbSubscription.subscription_type_id_label,
              issuedTimeAt: moment().format('YYYY-MM-DD hh:mm:ss')
            };

            let token = '';

            if (tokenValidityDays != null) {
              let expirationTime = moment().add(tokenValidityDays, 'days').format('YYYY-MM-DD hh:mm:ss');
              // JWT payload, with expiration time
              jwtPayload.expirationTime = expirationTime;

              // JWT token created, with expiration time for status = ['future','live','trial']
              token = jwt.sign(jwtPayload, cert, { expiresIn: tokenValidityDays*86400 });

              try {
                // Update id_token_expires_at in DB for current subscription
                SubscriptionModel.query(`UPDATE t_subscriptions SET id_token_expires_at='${expirationTime}' WHERE id_zoho_subscription = '${zohoSubscriptionId}'`, function (err, data) {
                  if (err) {
                    console.log(`Error updating expiration time into Db - ${zohoSubscriptionId} : `, err);
                  } else {
                    console.log(`Successfully updated expiration time into Db - ${zohoSubscriptionId} : `, data);
                  }
                })
              } catch (error) {
                console.log(`Internal server error: `, error);
              }
            }
            else {
              // JWT token created, without expiration time status != ['future','live','trial']
              token = jwt.sign(jwtPayload, cert, { algorithm: 'RS256'});
            }
            
            let obj = jwt.verify(token, cert);
            obj.token = token;

            res.status(200).json(obj);
          }
          else {
            res.status(404).json({message: "No such subscription"});
          }
        }
      })
    } catch (error) {
      console.log(`Internal server error: `, error);
      res.status(500).json(error);
    }
  },

  /**
   * zohoAuthController.renewZohoSubscription()
   */
  renewZohoSubscription: async function(req, res) {
    // Generate access token to create hosted pages update card for subscription renewal
    let accessToken = await generateAccessToken();
    let zohoSubscriptionId = req.params.zohoSubscriptionId;

    // Zoho API call to create hosted pages update card for subscription renewal
    axios({
      method: 'post',
      url: `https://subscriptions.zoho.com/api/v1/hostedpages/updatecard`,
      headers: {
        "X-com-zoho-subscriptions-organizationid": ZOHO.organizationId,
        "Authorization": `Zoho-oauthtoken ${accessToken}`,
        "Content-Type": "application/json;charset=UTF-8"
      },
      data: {
        "subscription_id": zohoSubscriptionId,
        "auto_collect": false,
        "redirect_url": `${ZOHO.redirect_uri}/subscription/${zohoSubscriptionId}/verify`
      }
    }).then(function (response) {
      console.log(response.data)

      // Update id_last_issue_date in DB for current subscription on successful hostedpage_id receival
      if (response.data.hostedpage && response.data.hostedpage.hostedpage_id) {
        let lastIssueDate = moment().format('YYYY-MM-DD hh:mm:ss');
        try {
          SubscriptionModel.query(`UPDATE t_subscriptions SET id_last_issue_date='${lastIssueDate}' WHERE id_zoho_subscription = '${zohoSubscriptionId}'`, function (err, data) {
            if (err) {
              console.log(`Error updating last issue date into Db - ${zohoSubscriptionId} : `, err);
            } else {
              console.log(`Successfully updated last issue date into Db - ${zohoSubscriptionId} : `, data);
            }
          })
        } catch (error) {
          console.log(`Internal server error: `, error);
        }
      }

      res.status(200).json(response.data);
    })
    .catch(function (err) {
      console.log(`Error updating card for a subscription from Zoho - ${zohoSubscriptionId} : `, err.response.data);
      res.status(500).json(err.response.data);
    });
  },

  /**
   * zohoAuthController.verifyZohoSubscription()
   */
  verifyZohoSubscription: async function(req, res) {
    // Generate access token to fetch one subscription with Zoho API
    let accessToken = await generateAccessToken();
    let zohoSubscriptionId = req.params.zohoSubscriptionId;
    // Fetch one subscription with Zoho API using generated access token
    zohoSubscription = await getOneSubscriptionFromZoho(zohoSubscriptionId, accessToken);

    try {
      // Find one subscription from DB
      SubscriptionModel.query(`SELECT * FROM t_subscriptions WHERE t_subscriptions.id_zoho_subscription='${zohoSubscriptionId}' LIMIT 1`, function (err, data) {
        if (err) {
          console.log(`Error finding subscription from Db - ${zohoSubscriptionId} : `, err);
    
          res.status(500).json(err);
        } else {
          let subscription = data[0];
          // Sync one subscription and its subscription type to DB
          findSubscriptionTypeFromDb(subscription, accessToken, zohoSubscription);
    
          res.status(200).json(zohoSubscription);
        }
      })
    } catch (error) {
      console.log(`Internal server error: `, error);
      res.status(500).json(error);
    }
  }
};
