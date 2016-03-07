azureQueue = require("azure-queue-node")
Promise = require("bluebird")

storageName = process.env.STORAGE_NAME
module.exports = Promise.promisifyAll azureQueue.setDefaultClient
  accountUrl: "http://#{storageName}.queue.core.windows.net/",
  accountName: storageName,
  accountKey: process.env.STORAGE_KEY

