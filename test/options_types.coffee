
should = require 'should'
parameters = require "../#{if process.env.PARAMETERS_COV then 'lib-cov' else 'src'}"
  
describe 'options type', ->

  describe 'string', ->

    it 'handle string option', ->
      params = parameters actions: [
        name: 'start'
        options: [
          name: 'watch'
          shortcut: 'w'
        ]
      ]
      params.parse(['start', '--watch', __dirname]).should.eql
        action: 'start'
        watch: __dirname
      params.stringify 
        action: 'start'
        watch: __dirname
      .should.eql ['start', '--watch', __dirname]

  describe 'boolean', ->

    it 'handle boolean option', ->
      params = parameters actions: [
        name: 'start'
        options: [
          name: 'strict'
          shortcut: 's'
          type: 'boolean'
        ]
      ]
      params.parse(['start', '-s']).should.eql
        action: 'start'
        strict: true
      params.stringify 
        action: 'start'
        strict: true
      .should.eql ['start', '--strict']

    it 'bypass a boolean option set to null', ->
      params = parameters
        options: [
          name: 'detached'
          shortcut: 'd'
          type: 'boolean'
        ]
      [].should.eql params.stringify 
        detached: null

  describe 'integer', ->

    it 'handle integer option', ->
      params = parameters actions: [
        name: 'start'
        options: [
          name: 'integer'
          shortcut: 'i'
          type: 'integer'
        ]
      ]
      params.parse(['start', '-i', '5']).should.eql
        action: 'start'
        integer: 5
      params.stringify 
        action: 'start'
        integer: 5
      .should.eql ['start', '--integer', '5']


