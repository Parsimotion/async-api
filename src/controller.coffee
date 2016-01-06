Promise = require("bluebird")
service = require("./azureQueueService")

processMessage = (message) ->
  return Promise.resolve() if message.method is "GET"

  service.createMessageAsync process.env.QUEUE_NAME, JSON.stringify message


module.exports = (request, response) =>
  console.log new Date()
  console.log JSON.stringify request
  console.log "----------"

  processMessage request
  .then ->
    response.writeHead 200
    response.end()
  .catch (err) ->
    response.writeHead err.statusCode, { "Content-Type": "application/json" }
    response.end JSON.stringify err
