#! Path configuration for the project dependencies.
require.config
  paths:
    # Collection of (extremely) useful utilities: <http://lodash.com/docs>.
    underscore: 'lib/underscore'

    # String manipulation extensions for underscore.
    'underscore-string':
      '../components/scripts/underscore.string/underscore.string'

    # Eases DOM manipulation.
    jquery: 'lib/jquery'

    # Core DOM manipulation library.
    'jquery-core': '../components/scripts/jquery/jquery'

    # Library that normalizes backbone and its extensions.
    backbone: 'lib/backbone'

    # Set of components and conventions powering Chaplin.
    'backbone-core': '../components/scripts/backbone/backbone'

    # Data binding utility library on top of backbone.
    'backbone-stickit':
      '../components/scripts/backbone.stickit/backbone.stickit'

    # Bootstrap (and plugins).
    bootstrap: '../components/scripts/bootstrap-sass/bootstrap'

    # Cookie manipulation normalization library.
    cookie: '../components/scripts/cookie-monster/monster'

    # Micro-template directory.
    templates: '../templates'

    # Core framework powering the single-page application
    chaplin: 'vendor/chaplin'

  shim:
    'underscore-string':
      exports: '_.str'

    'backbone-core':
      exports: 'Backbone'
      deps: [
        'jquery'
        'underscore'
      ]

    'backbone-stickit': ['backbone-core']

    bootstrap: ['jquery-core']

#! Instantiates the application and begins the execution cycle.
require ['app'], (Application) -> new Application().initialize()
