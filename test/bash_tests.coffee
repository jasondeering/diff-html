chai = require 'chai'
chai.should()

Bash = require '../lib/bash'

console.log JSON.stringify(Bash)

describe 'Bash', ->
  describe '#options_to_args', ->
    it 'should exist', ->
      Bash.options_to_args.should.exist

    it 'should be empty string for empty options', ->
      Bash.options_to_args({ }).should.equal ""

    describe 'single char option', ->
      it 'should have "-"', ->
        Bash.options_to_args({ a: true }).should.equal "-a"
      it 'should have value when not boolean', ->
        Bash.options_to_args({ a: 1 }).should.equal "-a 1"
      it 'should not be in string when set to false', ->
        Bash.options_to_args({ a: false }).should.equal ""