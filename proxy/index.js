var express = require('express');
var proxy = require('express-http-proxy');

var API_URL = process.env.API_URL;
var PORT = process.env.PORT || 3000;

var app = express();
app.use('/', express.static('../app'))
app.use('/api', proxy(API_URL));

app.listen(PORT);
console.log('Proxy started on port [' + PORT + ']');

