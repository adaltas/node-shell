
import {shell} from '../../lib/index.js'

describe 'options.cascade', ->
    
  it 'from root with unlimited level', ->
    app = shell
      options:
        'opt': cascade: true
      commands: 'server': commands: 'start': {}
    app.confx(['server', 'start']).options('opt').get()
    .should.eql
      cascade: true
      name: 'opt'
      type: 'string'
      transient: true
          
  it 'from root with unlimited level', ->
    app = shell
      options:
        'opt': cascade: true
      commands: 'server': commands: 'start': {}
    app.confx().get()
    .commands.server.commands.start.options.opt.transient
    .should.eql true
  
  it 'from command with unlimited level', ->
    app = shell
      commands: 'server':
        options:
          'opt': cascade: true
        commands: 'start': {}
    app.confx(['server', 'start']).options('opt').get()
    .should.eql
      cascade: true
      name: 'opt'
      type: 'string'
      transient: true
          
  it 'from root with limited level', ->
    app = shell
      options:
        'opt': cascade: 2
      commands: 'server': commands: 'start': commands: 'sth': {}
    app.confx(['server']).options.list()
    .should.eql ['help', 'opt']
    app.confx(['server', 'start']).options.list()
    .should.eql ['help', 'opt']
    app.confx(['server', 'start', 'sth']).options.list()
    .should.eql ['help']
        
  it 'from command with limited level', ->
    app = shell
      commands: 'server':
        options:
          'opt': cascade: 2
        commands: 'start': commands: 'sth': commands: 'else': {}
    app.confx().options.list()
    .should.eql ['help']
    app.confx(['server', 'start']).options.list()
    .should.eql ['help', 'opt']
    app.confx(['server', 'start', 'sth']).options.list()
    .should.eql ['help', 'opt']
    app.confx(['server', 'start', 'sth', 'else']).options.list()
    .should.eql ['help']
