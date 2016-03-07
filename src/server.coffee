http = require("http")
_ = require("lodash")
controller = require("./controller")
service = require("./azureQueueService")
Promise = require("bluebird")

module.exports = =>  
  port = process.env.PORT || 8081

  promise = if process.env.JOBS_QUEUE then service.createQueueAsync(process.env.JOBS_QUEUE) else Promise.resolve()
  promise.finally ->
    service.createQueueAsync(process.env.REQUESTS_QUEUE).finally -> 
      http.createServer (request, response) =>
        data = ""
        request.on "data", (chunk) => data += chunk
        request.on "end", =>
          req =
            method: request.method
            resource: request.url
            headers: request.headers
            body: data

          controller req, response
      .listen port

      console.log "[!] Listening in port #{port}"