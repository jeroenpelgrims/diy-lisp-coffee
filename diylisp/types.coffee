class LispError extends Error
    constructor: (message) ->
        @name = 'LispError'
        @message = message

module.exports.LispError = LispError