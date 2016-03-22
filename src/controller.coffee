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
  redis.pipeline().incr(jobId).exec (err, results) ->

processMessage = (message) ->
  return Promise.resolve() if message.method is "GET"
  if message.headers.job?
    try
      increaseJobTotalCount message.headers.job
    catch e
      console.log "redis error"   
    queue = process.env.JOBS_QUEUE
  else
    queue = process.env.REQUESTS_QUEUE
  service.putMessageAsync queue, message

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