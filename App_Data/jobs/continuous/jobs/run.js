require("coffee-script/register");
var tracker = require('coffee-redis-tracker');
var JobMessageProcessor = require('massive-operations-webjob/src/jobMessageProcessor');
tracker.wrapCounterAndTimerOverCallback(JobMessageProcessor, "process", "jobs");

var MessageFlowBalancer = require('massive-operations-webjob/src/messageFlowBalancer');
tracker.wrapCounterOverMethod(MessageFlowBalancer, "_asyncPush", "jobs");

var job = require('massive-operations-webjob');

options = {
  storageName: process.env.STORAGE_NAME,
  storageKey: process.env.STORAGE_KEY,
  baseUrl: process.env.BASE_URL_API,
  queue: process.env.JOBS_QUEUE,
  numOfMessages: process.env.JOBS_BATCH_SIZE || 16,
  visibilityTimeout: process.env.JOBS_VISIBILITY_TIMEOUT || 45,
  maxDequeueCount: process.env.JOBS_MAX_DEQUEUE_COUNT || 3,
  concurrency: process.env.JOBS_CONCURRENCY || 48,
  jobsQueue: true
};

if (process.env.JOBS_QUEUE) {
	job.run(options);
}
