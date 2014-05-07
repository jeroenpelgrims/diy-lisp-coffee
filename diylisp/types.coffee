class LispError extends Error
    constructor: (@message) ->

module.exports.LispError = LispError