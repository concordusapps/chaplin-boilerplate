module.exports = (grunt) ->

  # Underscore
  # ==========
  _ = grunt.util._

  # Package
  # =======
  pkg = require './package.json'

  # Grunt
  # =====
  grunt.initConfig

    # Cleanup
    # -------
    clean:
      build: 'build'
      temp: 'temp'
      bower: 'components'
      components: 'src/components'

    # Wrangling
    # ---------
    copy:
      options:
        excludeEmpty: true

      module:
        files: [
          dest: 'temp/scripts'
          cwd: 'temp/scripts:amd'
          expand: true
          src: [
            '**/*'
            '!main.js'
            '!vendor/**/*'
          ]
        ]

      static:
        files: [
          dest: 'temp'
          cwd: 'src'
          expand: true
          src: [
            '**/*'
            '!*.{coffee,scss,haml}'
          ]
        ]

      build:
        files: [
          dest: 'build/'
          cwd: 'temp'
          expand: true
          src: [
            '*',
            'styles/**/*.css',
            'media/**/*'
          ]
        ]

    # Compilation
    # -----------
    coffee:
      compile:
        files: [
          dest: 'temp/scripts/'
          src: '**/*.coffee'
          cwd: 'src/scripts'
          ext: '.js'
          expand: true
        ]

        options:
          bare: true

    # Dependency management
    # ---------------------
    bower:
      install:
        options:
          targetDir: './src/components'
          cleanup: true
          install: true

    # Module conversion
    # -----------------
    urequire:
      AMD:
        bundlePath: 'temp/scripts/'
        outputPath: 'temp/scripts:amd/'

    # Templates
    # ---------
    haml:
      options:
        uglify: true
        language: 'coffee'
        customHtmlEscape: 'haml.escape'
        customPreserve: 'haml.preserve'
        customCleanValue: 'haml.clean'
        dependencies:
          'haml': 'lib/haml'

      compile:
        files: [
          dest: 'temp/templates/'
          cwd: 'src/templates'
          ext: '.js'
          expand: true
          src: '**/*.haml'
        ]

        options:
          target: 'js'

      index:
        files:
          'temp/index.html': 'src/index.haml'

        options:
          context:
            requirejs: true

      build:
        files:
          'temp/index.html': 'src/index.haml'

    # Compass
    # -------
    compass:
      options:
        sassDir: 'src/styles'
        imagesDir: 'src/media/images'
        cssDir: 'temp/styles'
        javascriptsDir: 'temp/scripts'
        force: true
        relativeAssets: true

      compile:
        options:
          outputStyle: 'expanded'
          environment: 'development'

      build:
        options:
          outputStyle: 'compressed'
          environment: 'production'

    # Watch
    # -----
    watch:
      coffee:
        files: 'src/scripts/**/*.coffee'
        tasks: 'script'
        options:
          interrupt: true

      haml:
        files: 'src/templates/**/*.haml'
        tasks: 'haml:compile'
        options:
          interrupt: true

      index:
        files: 'src/index.haml'
        tasks: 'haml:index'
        options:
          interrupt: true

      compass:
        files: 'src/styles/**/*.scss'
        tasks: 'compass:compile'
        options:
          interrupt: true

    # Lint
    # ----
    coffeelint:
      gruntfile: 'Gruntfile.coffee'
      src: [
        'src/**/*.coffee'
        '!src/scripts/vendor/**/*'
      ]

    # Dependency tracing
    # ------------------
    requirejs:
      compile:
        options:
          out: 'build/scripts/main.js'
          include: _(grunt.file.expandMapping(['main*', 'controllers/**/*'], ''
            cwd: 'src/scripts/'
            rename: (base, path) -> path.replace /\.coffee$/, ''
          )).pluck 'dest'
          mainConfigFile: 'temp/scripts/main.js'
          baseUrl: './temp/scripts'
          keepBuildDir: true
          almond: true
          insertRequire: ['main']
          optimize: 'uglify'

    # Reporter
    # --------
    filesize:
      build: files: 'build/**/*'

    # Webserver
    # ---------
    connect:
      base: 'temp'
      hostname: 'localhost'
      port: 3501
      middleware: (connect, options) -> [
        connect.logger {immediate: true, format: 'dev'}
        require('connect-url-rewrite') ['^[^.]+$ /']
        connect.static options.base
        connect.directory options.base
      ]

  # Dependencies
  # ============
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name

  # Tasks
  # =====

  # Prepare
  # -------
  grunt.registerTask 'prepare', [
    'clean'
    'bower:install'
    'clean:bower'
  ]

  # Script
  # ------
  grunt.registerTask 'script', [
    'coffee:compile'
    'urequire'
    'copy:module'
  ]

  # Lint
  # ----
  grunt.registerTask 'lint', [
    'coffeelint'
  ]

  # Default
  # -------
  grunt.registerTask 'default', [
    'prepare'
    'copy:static'
    'script'
    'haml:compile'
    'haml:index'
    'compass:compile'
    'connect'
    'watch'
  ]

  # Build
  # -----
  grunt.registerTask 'build', [
    'prepare'
    'copy:static'
    'script'
    'haml:compile'
    'haml:build'
    'compass:build'
    'requirejs:compile'
    'copy:build'
    'filesize:build'
  ]
