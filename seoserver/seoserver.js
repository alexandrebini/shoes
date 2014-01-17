var express = require('express');
var app = express();

var getContent = function(url, callback) {
    var content = '';
    var phantom = require('child_process').spawn('phantomjs', ['phantom_server.js', url]);
    phantom.stdout.setEncoding('utf8');

    phantom.stdout.on('data', function(data) {
        content += data.toString();
    });

    phantom.on('exit', function(code) {
        if (code !== 0) {
            console.log('We have an error');
        } else {
            callback(content);
        }
    });
};

var respond = function(req, res) {
    url = 'http://' + req.headers['x-forwarded-host'] + req.params[0];
    console.log(url);
    getContent(url, function(content) {
        res.send(content);
    });
}

app.get(/(.*)/, respond);
app.listen(5001);