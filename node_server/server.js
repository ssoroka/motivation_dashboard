var http = require('http'),
    faye = require('./vendor/Faye-0.5.2/faye-node');

var server = new faye.NodeAdapter({mount: '/faye', timeout: 115});

server.listen(8000);
console.log('started');