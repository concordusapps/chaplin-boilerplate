#! Extensions to `Chaplin.Model` not merged into Chaplin for various
#! reasons.
#!
'use strict'

Chaplin = require 'chaplin'

#! Extends the chaplin model, well; we'll leave it a that.
module.exports = class Model extends Chaplin.Model

  # Mixin a synchronization state machine.
  _(@::).extend Chaplin.SyncMachine

  #! Name of the resource on the server (eg. 'accounts/user')
  name: undefined

  #! Generate a URL for this resource accessed as a model.
  url: ->
    if @get 'resource_uri'
      # This is a model synced with the server; go with it
      "/#{@get 'resource_uri'}"

    else if @id?
      # This is a request for a specific model from the server
      "/api/#{@name}/#{@id}/"

    else if @collection?
      # This is an unsynced member of a collection
      # There is nothing sane we can give in this situation
      # So just give the url of the collection.
      @collection.url()

    else
      # This is completely unsynced and not linked to a
      # collection; this shouldn't have a path
      # This is for creating models.
      "/api/#{@name}/"

  #! Facilitating the sync machine.
  fetch: (options = {}) ->
    # Initiate a syncing operation; magic for selectors
    @beginSync()

    # Wrap callbacks so the sync machine is facilitated properly
    options.success = _.wrap options.success, (initial, params...) =>
      initial.call(this, params...) if initial?
      @finishSync()

    options.error = _.wrap options.error, (initial, params...) =>
      initial.call(this, params...) if initial?
      @abortSync()

    # Send the request down the pipes
    super options

  dispose: ->
    return if @disposed
    # Ends all syncing operations
    @unsync()
    super
