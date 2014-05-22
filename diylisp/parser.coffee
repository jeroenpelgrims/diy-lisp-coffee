LispError = (require './types').LispError
isBoolean = (require './ast').isBoolean
isList = (require './ast').isList

parse = (source) ->
    source = source.replace /^\s+|\s+$/g, ''

    if /^#[tf]$/.test source
        source is '#t'
    else if /^\d+$/.test source
        parseInt source
    else if /^\w+$/.test source
        source
    else if /^'\w+$/.test source
        rest = source[1..]
        ['quote', parse rest]
    else if /^\(.*/.test source
        oldSource = source
        source = source[1...findMatchingParenthesis source]
        if oldSource.length - source.length > 2
            throw new LispError 'Expected EOF'
        parseMultiple source
    else
        source

removeComments = (source) ->
    source.replace /;.*\n/, '\n'

findMatchingParenthesis = (source, start=0) ->
    if not source[start] is '(' then throw Error 'Start should be opening parenthesis'

    pos = start
    openBrackets = 1
    while openBrackets > 0
        pos += 1
        if source.length == pos
            throw new LispError "Incomplete expression: #{source[start..]}"
        if source[pos] == '('
            openBrackets += 1
        if source[pos] == ')'
            openBrackets -= 1
    pos

splitExpressions = (source) ->
    rest = source.replace /^\s+|\s+$/g, ''
    exps = []
    while rest
        [exp, rest] = firstExpression rest
        exps.push exp
    exps

firstExpression = (source) ->
    source = source.replace /^\s+|\s+$/g, ''

    switch source[0]
        when ''
            [exp, rest] = firstExpression source[1..]
            return [source[0] + exp, rest]
        when '('
            last = findMatchingParenthesis source
            exp = source[..last + 1]
            rest = source[last + 1..]
            return [exp, rest]
        else
            re = /^[^\s)']+/
            match = source.match re
            end = (source.search re) + match[0].length
            atom = source[..end]
            return [atom, source[end..]]

parseMultiple = (source) ->
    source = removeComments source
    (parse exp for exp in splitExpressions(source))

unparse = (ast) ->
    if isBoolean ast
        return if ast then '#t' else '#f'
    else if isList ast
        if ast.length > 0 and ast[0] == quote
            return "'#{unparse ast[1]}"
        else
            s = [unparse x for x in ast].join ' '
            return "(#{s})"
    else
        return ast + ''

module.exports =
    parse: parse
    unparse: unparse