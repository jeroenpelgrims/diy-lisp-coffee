LispError = (require './types').LispError

parse = (source) ->
    throw Error 'DIY'

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
            open_brackets -= 1
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
            match = re.match(/^[^\s)']+/, source)
            end = match.end()
            atom = source[..end]
            return [atom, source[end..]]

parseMultiple = (source) ->
    source = removeComments source
    [parse(exp) for exp in splitExpressions(source)]

unparse = (ast) ->
    #TODO

module.exports.parse = parse