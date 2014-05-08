expect = (require 'chai').expect
parse = (require '../diylisp/parser').parse
unparse = (require '../diylisp/parser').unparse
LispError = (require '../diylisp/types').LispError

describe 'parser', ->

    it 'single symbol', ->
        expect(parse 'foo').to.equal 'foo'

    it 'boolean', ->
        expect(parse '#t').to.equal true
        expect(parse '#f').to.equal false

    it 'integer', ->
        expect(parse '42').to.equal 42
        expect(parse '1337').to.equal 1337

    it 'list of symbols', ->
        input = '(foo bar baz)'
        expect(parse input).to.equal ['foo', 'bar', 'baz']

        expect(parse '()').to.equal []

    it 'list of mixed types', ->
        program = '(foo (bar ((#t)) x) (baz y))'
        ast = [
            'foo',
            ['bar', [[true]], 'x'],
            ['baz', 'y']]
        expect(parse program).to.equal ast

     it 'missing parenthesis', ->
        expect(-> parse '(foo (bar x y)')
            .to.throw LispError, 'Incomplete expression'

    it 'extra parenthesis', ->
        expect(-> parse '(foo (bar x y)))')
            .to.throw LispError, 'Expected EOF'

    it 'remove extra whitespace', ->
        program = """

            (program with much whitespace)
        """

        expect(parse program)
            .to.equal ['program', 'with', 'much', 'whitespace']

    it 'strip comments', ->
        program = """
            (define fact
            ;; Factorial function
            (lambda (n)
                (if (<= n 1)
                    1 ; Factorial of 0 is 1, and we deny
                      ; the existence of negative numbers
                    (* n (fact (- n 1))))))
        """
        ast = ['define', 'fact',
                ['lambda', ['n'],
                    ['if', ['<=', 'n', 1],
                        1,
                        ['*', 'n', ['fact', ['-', 'n', 1]]]]]]

        expect(parse program)
            .to.equal ast

    it 'expand single quoted symbol', ->
        expect(parse '(foo \'nil)')
            .to.equal ["foo", ["quote", "nil"]]

    it 'nested quotes', ->
        expect(parse "''''foo")
            .to.equal ["quote", ["quote", ["quote", ["quote", "foo"]]]]

    it 'expand crazy quote combo', ->
        source = "'(this ''''(makes ''no) 'sense)"

        expect(unparse parse(source))
            .to.equal source

    it 'a', ->
        expect (unparse true)
            .to.equal '#t'