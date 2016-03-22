Promise = require("bluebird")
service = require("./azureQueueService")
Redis = require('ioredis')
redis = new Redis
  port: process.env.REDIS_PORT
  host: process.env.REDIS_HOST
  family: 4
  password: process.env.REDIS_AUTH
  db: 0

increaseJobTotalCount = (jobId) ->
  new Promise (resolve) ->
    # redis.pipeline().incr(jobId).exec (err, results) ->
    resolve()

putJobMessage = (message) ->
  increaseJobTotalCount(message.headers.job).then ->
    service.putMessageAsync process.env.JOBS_QUEUE, message

processMessage = (message) ->
  return Promise.resolve() if message.method is "GET"
  return putJobMessage(message) if message.headers.job?
  service.putMessageAsync process.env.REQUESTS_QUEUE, message

processRequest = (request, response, retries = 0) =>
  processMessage request
  .then ->
    console.log new Date(), "OK"
    console.log JSON.stringify request
    console.log "----------"
    response.writeHead 200
    response.end()
  .catch (err) ->
    return processRequest(request, response, retries + 1) if retries < 10
    console.log new Date(), "ERROR"
    console.log JSON.stringify request
    console.log "----------"
    console.log err
    console.log ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    response.writeHead (err.statusCode or 500)
    response.end JSON.stringify err

module.exports = processRequest