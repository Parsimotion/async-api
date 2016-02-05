Promise = require("bluebird")
service = require("./azureQueueService")

processMessage = (message) ->
  return Promise.resolve() if message.method is "GET"
  queue = if message.headers.job? then process.env.JOBS_QUEUE_NAME else process.env.REQUESTS_QUEUE_NAME
  service.createMessageAsync queue, JSON.stringify message

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
