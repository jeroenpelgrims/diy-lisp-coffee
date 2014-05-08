class LispError extends Error
    constructor: (@message) ->

class Closure
    constructor: (@message) ->
        throw Error 'DIY'


module.exports.LispError = LispError
module.exports.Closure = Closure