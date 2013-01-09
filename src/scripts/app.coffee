'use strict'

Chaplin  = require 'chaplin'
routes   = require 'routes'

#! The main object; represents the entirety of the app.
module.exports = class Application extends Chaplin.Application

  #! Initialize the application; set up the global context.
  initialize: ->
    super

    # Initialize chaplin core, passing in any appropriate options.
    @initDispatcher controllerSuffix: ''
    @initLayout()
    @initComposer()
    @initControllers()
    @initMediator()

    # Register all routes and start routing.
    @initRouter routes

    # Freeze the object instance; prevent further changes.
    Object.freeze? @

  initMediator: ->
    # Attach any semi-globals here.
    Chaplin.mediator.seal()

  initControllers: ->
    # Instantiate any persistent controllers here.
