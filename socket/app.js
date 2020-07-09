const express = require('express');
const http = require('http');
const socketIO = require('socket.io');

var PORT = 3001;

var app = express();
app.use(express.json());
var server = http.createServer(app);
server.listen(PORT, '0.0.0.0');

var io = socketIO.listen(server);
io.set('heartbeat interval', 30000);
io.set('heartbeat timeout', 30000);
io.set('origins', '*:*');

io.on('connection', function(socket) {
  console.log('a user connected');
});