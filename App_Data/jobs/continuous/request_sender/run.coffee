Promise = require("bluebird")
service = require("./azureQueueService")

queueName = process.env.QUEUE_NAME

receive = ->
  console.log "Looking for new messages..."
  service.getMessagesAsync(queueName).spread (messages) ->
    console.log "New messages:", messages
    if messages.length is 0 then return receive()

    Promise.all messages.map (message) ->
      { messageid: id, messagetext: req, popreceipt } = message
      console.log "New message:", req

      service.deleteMessageAsync(queueName, id, popreceipt).then ->
        console.log "Ya lo borré"

    .then receive

receive()
