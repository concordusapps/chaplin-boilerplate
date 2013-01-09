'use strict'

Controller = require 'lib/controllers/controller'
View       = require 'views/index'

module.exports = class Index extends Controller

  show: ->
    @view = new View
    @view.render()
