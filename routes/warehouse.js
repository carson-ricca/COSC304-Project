const express = require('express');
const router = express.Router();
const sql = require('mssql');
const auth = require('../auth');

router.get('/', function(req, res, next) {

    let productId = req.query.productId;
    let warehouseId = req.query.warehouseId;
    let newquantity = req.query.quantity;

            const query = `SELECT * FROM productinventory WHERE productId = @productId AND warehouseId = @warehouseId`;
            let pool = await sql.connect(dbConfig);
            let results = await pool.request()
                .input('productId', sql.Int, productId)
                .input('warehouseId', sql.Int, warehouseId)
                .query(query);

            if (results.recordset.length === 0) {
                res.render('message', {
                    type: 'danger',
                    message: 'Product not found in the warehouse mentioned!',
                });
                return;
            }

        (async function () {
            try {
                let pool = await sql.connect(dbConfig);

                let result = await pool.request()
                .input('productId', sql.Int, productId)
                .input('warehouseId', sql.Int, warehouseId)
                .query("SELECT quantity, warehouseId, productId FROM productinventory WHERE productId = @productId AND warehouseId = @warehouseId");
                
                res.render('warehouse', {
                title: 'Warehouse Page',
                info: result.recordset
                });
                
                await pool.request()
                .input('productId', sql.Int, productId)
                .input('warehouseId', sql.Int, warehouseId)
                .input('quantity', sql.Int, newquantity)
                .query("UPDATE productinventory SET quantity = @newquantity WHERE productId = @productId AND warehouseId = @warehouseId");

                res.render('message', {
                type: 'update',
                message: 'Product Inventory Updated!',
                });
                }
                
            })();catch (err) {
                console.dir(err);
                res.render('message', {
                    type: 'danger',
                    message: err,
                })
            }
        })();
    
};
module.exports = router;