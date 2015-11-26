Promise = require("bluebird")
request = Promise.promisifyAll require("request")
service = require("./azureQueueService")
_ = require("lodash")

queueName = process.env.QUEUE_NAME

processMessage = (req) ->
  method = req.method.toLowerCase()
  url = process.env.BASE_URL + req.resource
  options = _.pick req, "headers", "body"

  request["#{method}Async"](url, options).spread ({ statusCode, body }) =>
    if not /2../.test statusCode
      throw body

    body

receive = ->
  console.log "Looking for new messages..."

  service.getMessagesAsync(queueName).spread (messages) ->
    console.log "New messages:", messages
    if messages.length is 0 then return receive()

    Promise.all messages.map (message) ->
      deleteMessage = -> service.deleteMessageAsync queueName, id, popreceipt

      { messageid: id, messagetext: req, popreceipt } = message
      console.log "Processing message:", req

      processMessage(JSON.parse(req))
        .then (response) ->
          console.log "OK!", response
        .catch (error) ->
          console.log "ERROR!", error
        .finally -> deleteMessage()

    .then receive

receive()
