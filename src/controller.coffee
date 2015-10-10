service = require("./azureQueueService")

module.exports = (request, response) =>
  console.log new Date()
  console.log JSON.stringify request
  console.log "----------"

  enqueue = (message) =>
    service.createMessageAsync process.env.QUEUE_NAME, JSON.stringify(message)

##########################

  enqueue request
  .then (algo) ->
    response.writeHead 200
    response.end()
  .catch (err) ->
    response.writeHead err.statusCode, { "Content-Type": "application/json" }
    response.end JSON.stringify err
