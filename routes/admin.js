const express = require('express');
const router = express.Router();
const auth = require('../auth');
const sql = require('mssql');

router.get('/', function(req, res, next) {
    if(auth.checkAuthentication(req, res)) {
        const query = "SELECT CONVERT(varchar, orderDate, 23) as dateOrdered, SUM(totalAmount) as totalAmountEarned FROM ordersummary GROUP BY CONVERT(varchar, orderDate, 23) ORDER BY CONVERT(varchar, orderDate, 23)";
        (async function() {
            try {
                let pool = await sql.connect(dbConfig);
                let result = await pool.request()
                    .query(query);

                const sales = result.recordset;
                let chartLabels = [];
                let chartData = [];
                for(let i = 0; i < sales.length; i++){
                    chartLabels.push(sales[i].dateOrdered);
                    chartData.push(sales[i].totalAmountEarned);
                }

                res.render('admin', {
                    title: 'Admin Sales Report',
                    sales: sales,
                    chartLabels: JSON.stringify(chartLabels),
                    chartData: JSON.stringify(chartData),
                });
            } catch(err) {
                console.dir(err);
                res.render('message', {
                    type: 'danger',
                    message: err,
                })
            }
        })();
    }
});

module.exports = router;
