var express = require('express');
var app = express();

app.use("/app", express.static("app"));
app.use("/bower_components", express.static("bower_components"));

app.get('/*', function (req, res) {
  res.sendfile('index.html');
});

app.listen(7000, function () {
  console.log('Corriendo en puerto 7000');
});
