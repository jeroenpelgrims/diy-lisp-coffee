LispError = (require './types').LispError

parse = (s) ->
    throw new LispError 'Incomplete expression'

module.exports.parse = parse