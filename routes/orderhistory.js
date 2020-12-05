const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function (req, res, next) {
    let username;
    if (auth.checkAuthentication(req, res)) {
        username = req.session.authenticatedUser;

        (async function () {
            try {
                const userQuery = "SELECT customerId FROM customer WHERE userid = @username";
                let pool = await sql.connect(dbConfig);
                let result = await pool.request()
                    .input('username', sql.VarChar, username)
                    .query(userQuery);
                let customerId = result.recordset[0].customerId;

                const orderQuery = "SELECT orderId, orderDate, totalAmount FROM orderSummary WHERE customerId = @customerId";
                let result2 = await pool.request()
                    .input('customerId', sql.Int, customerId)
                    .query(orderQuery);

                res.render('orderhistory', {
                    title: 'Order History',
                    orders: result2.recordset
                })
            } catch (err) {
                console.dir(err);
                res.render('message', {
                    type: 'danger',
                    message: err,
                });
            }
        })();
    }
});

module.exports = router;
