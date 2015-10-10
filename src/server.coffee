http = require("http")
_ = require("lodash")
controller = require("./controller")
service = require("./azureQueueService")

module.exports = =>  
  port = process.env.PORT || 8081
  service.createQueueIfNotExistsAsync(process.env.QUEUE_NAME).then -> 
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