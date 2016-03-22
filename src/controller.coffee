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
