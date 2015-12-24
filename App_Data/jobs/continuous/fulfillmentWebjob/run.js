require("coffee-script/register");
var job = require('massive-operations-webjob');

job
.create(process.env.STORAGE_NAME, process.env.STORAGE_KEY, process.env.BASE_URL_API)
.processMessage(process.env.QUEUE_NAME);
