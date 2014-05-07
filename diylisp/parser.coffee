LispError = (require './types').LispError

parse = (s) ->
    throw new LispError 'Expected EOF'

module.exports.parse = parse