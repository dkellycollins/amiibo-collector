var express = require('express');
var proxy = require('express-http-proxy');
var path = require('path');

var API_URL = process.env.API_URL;
var PORT = process.env.PORT || 3000;
var APP_PATH = './';
var ASSETS_PATH = './assets';

var app = express();
app.use('/', express.static(APP_PATH))
app.use('/api', proxy(API_URL));
app.use('/assets', express.static(ASSETS_PATH));

app.listen(PORT);
console.log('Proxy started on port [' + PORT + ']');
