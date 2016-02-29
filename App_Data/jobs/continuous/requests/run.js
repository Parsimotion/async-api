var job = require('massive-operations-webjob');

options = {
  storageName: process.env.STORAGE_NAME,
  storageKey: process.env.STORAGE_KEY,
  baseUrl: process.env.BASE_URL_API,
  queue: process.env.REQUESTS_QUEUE,
  maxMessages: process.env.REQUESTS_BATCH_SIZE || 16,
  maxDequeueCount: process.env.REQUESTS_MAX_DEQUEUE_COUNT || 3,
  concurrency: process.env.REQUESTS_CONCURRENCY || 48,
  jobsQueue: false
};

process.on('uncaughtException',function(err){
  console.log("Caught exception: ", err);
});

job.run(options);
