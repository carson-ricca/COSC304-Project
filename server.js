const express = require('express');
const hbs = require('./utils/express-handlebars');
const session = require('express-session');
const redis = require('redis');
const connectRedis = require('connect-redis');

let loadData = require('./routes/loaddata');
let listOrder = require('./routes/listorder');
let listProd = require('./routes/listprod');
let addCart = require('./routes/addcart');
let showCart = require('./routes/showcart');
let checkout = require('./routes/checkout');
let order = require('./routes/order');
let customer = require('./routes/customer');
let product = require('./routes/product');
let displayImage = require('./routes/displayImage');
let admin = require('./routes/admin');
let login = require('./routes/login');
let logout = require('./routes/logout');
let index = require('./routes/index');
let validateLogin = require('./routes/validateLogin');
let ship = require('./routes/ship');
let productReview = require('./routes/review');
let processReview = require('./routes/processReview');
let addPaymentMethod = require('./routes/addPaymentMethod');
let register = require('./routes/register');
let warehouse = require('./routes/warehouse/warehouse');

const app = express();

// This DB Config is accessible globally
dbConfig = {
    user: process.env.username,
    password: process.env.password,
    server: process.env.host,
    database: process.env.database,
    options: {
        'encrypt': true,
    }
};

const redisStore = connectRedis(session);
const redisClient = redis.createClient(process.env.REDIS_URL);

redisClient.on('error', function (err) {
    console.log('Could not connect to Redis.' + err);
});

redisClient.on('connect', function () {
    console.log('Connect to Redis succesfully.');
});
app.use(session({
    store: new redisStore({client: redisClient}),
    secret: 'COSC 304 Rules!',
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: false,
        secure: false,
        maxAge: 60000,
    }
}));

// Setting up the rendering engine
app.engine('handlebars', hbs.engine);
app.set('view engine', 'handlebars');

// Setting up Express.js routes.
// These present a "route" on the URL of the site.
// Eg: http://127.0.0.1/loaddata
app.use(express.json());
app.use(express.urlencoded({extended: false}));
app.use('/loaddata', loadData);
app.use('/listorder', listOrder);
app.use('/listprod', listProd);
app.use('/addcart', addCart);
app.use('/showcart', showCart);
app.use('/checkout', checkout);
app.use('/order', order);
app.use('/customer', customer);
app.use('/product', product);
app.use('/displayimage', displayImage);
app.use('/admin', admin);
app.use('/login', login);
app.use('/logout', logout);
app.use('/validateLogin', validateLogin);
app.use('/ship', ship);
app.use('/review', productReview);
app.use('/processreview', processReview);
app.use('/addPaymentMethod', addPaymentMethod);
app.use('/register', register);
app.use('/warehouse', warehouse);
app.use('/', index);
app.use(express.static('public/'));

// Rendering the main page
app.get('/', function (req, res) {
    res.render('index', {
        title: "Electric Lettuce"
    });
});

// Starting our Express app
app.listen(process.env.PORT || 3000);
