should = (require 'chai').should()
parser = require '../diylisp/parser'

describe 'parser', () ->

    it 'single symbol', () ->
        (parser.parse 'foo').should.equal 'foo'

    it 'boolean', () ->
        (parser.parse '#t').should.equal true
        (parser.parse '#f').should.equal false

    it 'integer', () ->
        (parser.parse '42').should.equal 42
        (parser.parse '1337').should.equal 1337

    it 'list of symbols', () ->
        input = '(foo bar baz)'
        (parser.parse input).should.equal ['foo', 'bar', 'baz']
        (parser.parse '()').should.equal []

    it 'list of mixed types', () ->
        program = '(foo (bar ((#t)) x) (baz y))'
        ast = [
            'foo',
            ['bar', [[true]], 'x'],
            ['baz', 'y']]
        (parser.parse program).should.equal ast

    #TODO: complete tests: https://github.com/kvalle/diy-lisp/blob/master/tests/test_1_parsing.py