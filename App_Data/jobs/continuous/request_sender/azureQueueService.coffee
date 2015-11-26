azure = require("azure-storage")
Promise = require("bluebird")
Promise.promisifyAll azure # An Azure Full Of Promises
                           # https://www.youtube.com/watch?v=LFvoS9V-7ys

module.exports = azure.createQueueService process.env.STORAGE_NAME, process.env.STORAGE_KEY
