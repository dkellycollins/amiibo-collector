var express = require('express');
var proxy = require('express-http-proxy');
var path = require('path');

var API_URL = process.env.API_URL || 'https://amiibos-api.herokuapp.com';
var PORT = process.env.PORT || 3000;
var APP_PATH = './';
var MEDIA_URL = process.env.MEDIA_URL || 'https://media.githubusercontent.com/media/dkellycollins/amiibo-collector/master/assets';

var app = express();
app.use('/', express.static(APP_PATH))
app.use('/api', proxy(API_URL));
app.use('/assets', proxy(MEDIA_URL));

app.listen(PORT);
console.log('Proxy started on port [' + PORT + ']');
