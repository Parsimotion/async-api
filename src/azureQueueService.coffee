azure = require("azure-storage")
Promise = require("bluebird")
Promise.promisifyAll azure

module.exports = azure.createQueueService process.env.STORAGE_NAME, process.env.STORAGE_KEY
