Closure = (require './types').Closure

isSymbol = (x) ->
    typeof x is 'string'

isList = (x) ->
    x instanceof Array

isBoolean = (x) ->
    typeof x is 'boolean'

isInteger = (x) ->
    typeof x is 'number'

isClosure = (x) ->
    x instanceof Closure

isAtom = (x) ->
    return isSymbol x or isInteger x or isBoolean x or isClosure x

module.exports =
    isSymbol: isSymbol
    isList: isList
    isBoolean: isBoolean
    isInteger: isInteger
    isClosure: isClosure
    isAtom: isAtom