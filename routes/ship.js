const express = require('express');
const router = express.Router();
const sql = require('mssql');
const moment = require('moment');

router.get('/', function(req, res, next) {
    res.setHeader('Content-Type', 'text/html');

	// TODO: Get order id
	let orderid = req.query.orderId;


	let query2 = "SELECT quantity FROM orderproduct WHERE orderId = @orderId";
	let query3 = "SELECT quantity FROM productinventory JOIN incart WHERE productinventory.productId = incart.productId WHERE orderId = @orderId AND warehouseId = 1"
	//wquantity is the quantity from prodinventory. Symbolizes quantity for warehouse hopefully

	// TODO: Check if valid order id

	if (!(isNan(orderid))) {
        let query1 = // TODO: Retrieve all items in order with given id
		"SELECT * FROM orderProduct WHERE orderId = @orderId";
    }


    (async function() {
        try {
			// TODO: Start a transaction

		let pool = await sql.connect(dbConfig);

		const transaction = new sql.Transaction(pool);
            transaction.begin(async err => {

	let results = await pool.request().input('orderId', sql.Int, orderid).query(query1);


	let orderquantityresults = await pool.request().input('orderId', sql.Int, orderid).query(query2);
	let warehousequantityresults = await pool.request().input('orderId', sql.Int, orderid).query(query3);

	let success = true;

 	for(let i = 0; i<orderquantityresults.recordset.length; i++){
		let orderquantity = [];
		let warehousequantity = [];
	 orderquantity[i] = orderquantityresults.recordset[i];
	 warehousequantity[i] = warehousequantityresults.recordset[i];


	if(orderquantity[i] > warehousequantity[i]){// TODO: For each item verify sufficient quantity available in warehouse 1.
	   success = false;
	   break;
	}

	let newquantity = []
	newquantity = warehousequantity[i] - orderquantity[i];
	let updatequery = "UPDATE productinventory JOIN incart SET quantity = @newquantity WHERE productinventory.productId = incart.productId WHERE orderId = @orderId AND warehouseId = 1 "
	updatequery = await pool.request().input('newquantity', sql.Int, newquantity).query(updatequery);	//update inventory with new quantity. dont know how to have multiple inputs

	let insertquery = "INSERT INTO shipment (shipmentdate, warehouseId) VALUES (GETDATE(), 1)" // warehouse id and date
	insertquery = await pool.request().query(insertquery);// TODO: Create a new shipment record.

	}

	}


	if(success = true){

	await transaction.commit();

	}else

	await transaction.rollback();




        } catch(err) {
            console.dir(err);
            res.write(err + "")
            res.end();
		}

    })();
});

module.exports = router;

