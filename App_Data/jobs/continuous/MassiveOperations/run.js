require("coffee-script/register");
var async = require('async');
var job = require('massive-operations-webjob');

var processor = job.create(process.env.STORAGE_NAME, process.env.STORAGE_KEY, process.env.BASE_URL_API)

var q = async.queue(function (queue, callback) {
  processor.processMessage(queue)
  .then(function() {
  	console.log("PROCESS FINISHED SUCCESS");
	callback()
  })
  .catch(function(err) {
  	console.log("PROCESS FINISHED ERROR");
  	console.log(err);
    callback(err)
  })
}, process.env.PARALLEL_PROCESS_COUNT || 1);

async.forever(
  function(next) {
  	q.push(process.env.QUEUE_NAME)
  	next()
  }
);
