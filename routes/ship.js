const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');

router.get('/', function (req, res, next) {
    (async function () {
        try {
            let orderId = req.query.orderId;

            const query = `SELECT * FROM ordersummary WHERE orderId = @orderId`;
            let pool = await sql.connect(dbConfig);
            let results = await pool.request()
                .input('orderId', sql.Int, orderId)
                .query(query);

            if (results.recordset.length === 0) {
                res.render('message', {
                    type: 'danger',
                    message: 'Order not found!',
                });
                return;
            }

            const tx = pool.transaction();
            tx.begin(err => {
                (async function f() {
                    await tx.request()
                        .input('date', sql.Date, new Date(Date.now()))
                        .query(`INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (@date, '', 1)`);

                    await tx.request()
                        .input('orderId', sql.Int, orderId)
                        .query(`UPDATE ordersummary SET shipped = 'true' WHERE orderId = @orderId`);

                    let results = await tx.request()
                        .input('orderId', sql.Int, orderId)
                        .query(`SELECT * FROM orderproduct WHERE orderId = @orderId`);

                    const products = results.recordset;

                    for(let i = 0; i < products.length; i++) {
                        let results = await tx.request()
                            .input('productId', sql.Int, products[i].productId)
                            .query(`SELECT quantity FROM productinventory WHERE productId = @productId`);
                        let quantity = results.recordset[0].quantity;

                        console.dir(quantity);

                        if (products[i].quantity > quantity) {
                            tx.rollback();
                            res.render('message', {
                                type: 'danger',
                                message: 'Shipment not done. Insufficient inventory for product id: ' + products[i].productId,
                            });
                            return;
                        } else {
                            await tx.request()
                                .input('productId', sql.Int, products[i].productId)
                                .input('quantity', sql.Int, quantity - products[i].quantity)
                                .query(`UPDATE productinventory SET quantity = @quantity WHERE productId = @productId`);
                        }
                    }
                    await tx.commit();
                    res.render('message', {
                        type: 'success',
                        message: 'Successfully shipped',
                    })
                })();
            })
        } catch (err) {
            console.dir(err);
        }
    })();
});

module.exports = router;
