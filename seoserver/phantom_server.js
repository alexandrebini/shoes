var system = require('system');
var page = require('webpage').create();
var timeout = 40000;
var startTime = new Date().getTime();
var isLoaded = false

page.onLoadStarted = function(request) {
    startTime = new Date().getTime();
    isLoaded = false;
};

page.onLoadFinished = function(response) {
    isLoaded = page.evaluate(function() {
        return document.getElementsByClassName('is-loading').length == 0;
    });
};

var checkComplete = function() {
    if (isLoaded || new Date().getTime() - startTime > timeout) {
        clearInterval(checkCompleteInterval);
        console.log(page.content);
        phantom.exit();
    }
}

page.open(system.args[1], function(status) {});

var checkCompleteInterval = setInterval(checkComplete, 1);