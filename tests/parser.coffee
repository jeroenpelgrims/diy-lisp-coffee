expect = (require 'chai').expect
parse = (require '../diylisp/parser').parse
LispError = (require '../diylisp/types').LispError

describe 'parser', () ->

    it 'single symbol', () ->
        expect(parse 'foo').to.equal 'foo'

    it 'boolean', () ->
        expect(parse '#t').to.equal true
        expect(parse '#f').to.equal false

    it 'integer', () ->
        expect(parse '42').to.equal 42
        expect(parse '1337').to.equal 1337

    it 'list of symbols', () ->
        input = '(foo bar baz)'
        expect(parse input).to.equal ['foo', 'bar', 'baz']

        expect(parse '()').to.equal []

    it 'list of mixed types', () ->
        program = '(foo (bar ((#t)) x) (baz y))'
        ast = [
            'foo',
            ['bar', [[true]], 'x'],
            ['baz', 'y']]
        expect(parse program).to.equal ast

     it 'missing parenthesis', () ->
        expect(() -> parse '(foo (bar x y)')
            .to.throw (new LispError 'Incomplete expression')

    #TODO: complete tests: https://github.com/kvalle/diy-lisp/blob/master/tests/test_1_parsing.py