const express = require('express');
const router = express.Router();
const auth = require('../auth');
const sql = require('mssql');

router.post('/', function (req, res) {
    // Have to preserve async context since we make an async call
    // to the database in the validateLogin function.
    (async () => {
        let authenticatedUser = await validateLogin(req);
        if (authenticatedUser) {
            res.redirect(req.session.url ? req.session.url : '/');
        } else {
            res.redirect("/login");
        }
    })();
});

async function validateLogin(req) {
    if (!req.body || !req.body.username || !req.body.password) {
        return false;
    }
    let username = req.body.username;
    let password = req.body.password;
    let query = "SELECT customerId FROM customer WHERE userid = @username AND password = @password";
    return await (async function () {
        try {
            let pool = await sql.connect(dbConfig);
            let result = await pool.request()
                .input('username', sql.VarChar, username)
                .input('password', sql.VarChar, password)
                .query(query);
            // TODO: Check if userId and password match some customer account.
            // If so, set authenticatedUser to be the username.
            if (result.recordset[0]) {
                req.session.authenticatedUser = username;
                req.session.authenticatedUserId = result.recordset[0].customerId;
                return true;
            } else {
                return false;
            }

        } catch (err) {
            console.dir(err);
            return false;
        }
    })();
}

module.exports = router;
