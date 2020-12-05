const express = require('express');
const router = express.Router();
const sql = require('mssql');

router.get('/', function (req, res, next) {
    // Get product id
    let productId = req.query.id;

    const query = "SELECT * FROM product WHERE productId = @id";
    const query2 = "SELECT reviewRating, enteredName, reviewComment, CONVERT(varchar, reviewDate, 23) as date FROM review WHERE productId = @pid";
    (async function () {
        try {
            let pool = await sql.connect(dbConfig);

            let result = await pool.request()
                .input('id', sql.Int, productId)
                .query(query);

            let reviews = await pool.request()
                .input('pid', sql.Int, productId)
                .query(query2);

            res.render('product/detail', {
                title: 'Product Details',
                product: result.recordset[0],
                reviews: reviews.recordset
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }

    })();
});

router.get('/add', function (req, res, next) {
    (async function f() {
        try {
            let pool = await sql.connect(dbConfig);
            const warehouses = (await pool.request().query(`SELECT *
                                                            FROM warehouse`)).recordset;
            const categories = (await pool.request().query(`SELECT *
                                                            FROM category`)).recordset;
            res.render('product/add', {
                warehouses: warehouses,
                categories: categories,
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }
    })();
});

router.post('/add', function (req, res, next) {

    (async function f() {
        try {
            const warehouseId = req.body.warehouse;
            const categoryId = req.body.category;
            const name = req.body.name;
            const price = req.body.price;
            const description = req.body.description;
            const quantity = req.body.quantity;

            let pool = await sql.connect(dbConfig);
            let result = await pool.request()
                .input('name', sql.VarChar, name)
                .input('price', sql.Decimal(10, 2), price)
                .input('desc', sql.VarChar, description)
                .input('categoryId', sql.Int, categoryId)
                .query(`INSERT INTO product (productName, productPrice, productDesc, categoryId)
                        VALUES (@name, @price, @desc, @categoryId);
                SELECT SCOPE_IDENTITY();`);
            const productId = result.recordset[0][''];
            await pool.request()
                .input('productId', sql.Int, productId)
                .input('warehouseId', sql.Int, warehouseId)
                .input('quantity', sql.Int, quantity)
                .input('price', sql.Decimal(10, 2), price)
                .query(`INSERT INTO productinventory (productId, warehouseId, quantity, price)
                        VALUES (@productId, @warehouseId, @quantity, @price)`);
            res.render('message', {
                type: 'success',
                message: 'Product Added Successfully',
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }
    })();
});

router.get('/:id/edit', function (req, res, next) {
    (async function f() {
        try {
            const productId = req.params.id;

            let pool = await sql.connect(dbConfig);
            const warehouses = (await pool.request().query(`SELECT *
                                                            FROM warehouse`)).recordset;
            const categories = (await pool.request().query(`SELECT *
                                                            FROM category`)).recordset;
            const product = (await pool.request()
                .input('productId', sql.Int, productId)
                .query(
                        `SELECT product.productId,
                                quantity,
                                productPrice,
                                productName,
                                productDesc,
                                warehouseId,
                                categoryId
                         FROM product
                                  INNER JOIN productinventory ON product.productId = productinventory.productId
                         WHERE product.productId = @productId`
                )).recordset[0];
            res.render('product/edit', {
                warehouses: warehouses,
                categories: categories,
                product: product,
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }
    })();
});

router.post('/:id/edit', function (req, res, next) {
    (async function f() {
        try {
            const productId = req.params.id;
            const warehouseId = req.body.warehouse;
            const categoryId = req.body.category;
            const name = req.body.name;
            const price = req.body.price;
            const description = req.body.description;
            const quantity = req.body.quantity;

            let pool = await sql.connect(dbConfig);
            await pool.request()
                .input('name', sql.VarChar, name)
                .input('price', sql.Decimal(10, 2), price)
                .input('desc', sql.VarChar, description)
                .input('categoryId', sql.Int, categoryId)
                .input('productId', sql.Int, productId)
                .query(
                        `UPDATE product
                         SET productName  = @name,
                             productPrice = @price,
                             productDesc  = @desc,
                             categoryId   = @categoryId
                         WHERE productId = @productId
                    `);
            await pool.request()
                .input('productId', sql.Int, productId)
                .input('warehouseId', sql.Int, warehouseId)
                .input('quantity', sql.Int, quantity)
                .input('price', sql.Decimal(10, 2), price)
                .query(`UPDATE productinventory
                        SET warehouseId = @warehouseId,
                            quantity    = @quantity,
                            price       = @price
                        WHERE productId = @productID
                `);
            res.render('message', {
                type: 'success',
                message: 'Product Added Successfully',
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }
    })();
});

router.get('/:id/delete', function (req, res, next) {
    (async function f() {
        try {
            const productId = req.params.id;

            let pool = await sql.connect(dbConfig);
            await pool.request()
                .input('productId', sql.Int, productId)
                .query(`DELETE
                        FROM productinventory
                        WHERE productId = @productID
                `);
            await pool.request()
                .input('productId', sql.Int, productId)
                .query(
                        `DELETE
                         FROM product
                         WHERE productId = @productId
                    `);
            res.render('message', {
                type: 'success',
                message: 'Product Deleted Successfully',
            });
        } catch (err) {
            console.dir(err);
            res.render('message', {
                type: 'danger',
                message: err,
            })
        }
    })();
});

module.exports = router;
