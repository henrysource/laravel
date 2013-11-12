module.exports = (grunt) =>
    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        phplint:
            files: ['app/**/*.php', 'bootstrap/**/*.php', 'public/**/*.php']

        phpunit:
            classes:
                dir: 'app/tests'
            options:
                bin: 'vendor/bin/phpunit'
                configuration: 'phpunit.xml'
                verbose: true

        shell:
            bundle:
                command: 'bundle install'
                options:
                    stdout: true

            npm_install:
                command: 'npm install'
                options:
                    stdout: true

            composer:
                command: 'composer install'
                options:
                    stdout: true

            composer_update:
                command: 'composer update'
                options:
                    stdout: true

        ## Growl notifications
        notify:
            compass:
                options:
                    title: "CSS Files built"
                    message: "Compass task complete"
            coffee:
                options:
                    title: "CoffeeScript Files built"
                    message: "Coffee task complete"

            production:
                options:
                    title: "Build Complete"
                    message: "The production environment has been optimized"

        notify_hooks:
            options:
                enabled: true

        modernizr:
            devFile: "remote"
            outputFile: "public/assets/scripts/compiled/modernizr.js"
            extra:
                shiv: false
                printshiv: false
                load: false
                mq: false
                cssclasses: true

            extensibility:
                addtest: false
                prefixed: false
                teststyles: false
                testprops: false
                testallprops: false
                hasevents: false
                prefixes: false
                domprefixes: false

            uglify: true
            ## Test names https://github.com/Modernizr/modernizr.com/blob/gh-pages/i/js/modulizr.js#L15-157
            tests: [

            ]
            parseFiles: true
            files: []
            matchCommunityTests: false
            customTests: [
                'public/assets/scripts/compiled/modernizr/*.js'
            ]
            excludeFiles: []

        ## Run tasks when files are modified
        watch:
            npm:
                files: ['package.json']
                tasks: 'shell:npm_install'

            sass:
                ## Compile SCSS when scss or sass file are modified, or items in the sprites directory are modified
                files: ['public/sass/**/*.{scss,sass}','public/assets/images/sprites/**/*.png','public/assets/fonts/**/*']
                tasks: ['compass:app', 'notify:compass']

            coffee:
                files: ['public/coffee/**/*.coffee','!public/coffee/config.coffee']
                tasks: ['coffee:app']
                options:
                    spawn: false

            coffee_config:
                files: ['public/coffee/config.coffee']
                tasks: ['coffee:config', 'bowerrjs']

            bower:
                files: 'bower.json'
                tasks: ['bower']

            composer:
                files: 'composer.json'
                tasks: ['shell:composer_update']

            bundle:
                files: 'Gemfile'
                tasks: ['shell:bundle']

            modernizr:
                files: ['public/coffee/modernizr/*']
                tasks: ['modernizr_build']

            test:
                files: ['app/**/*.php', 'bootstrap/**/*.php', 'public/**/*.php']
                tasks: ['test']

        ## Compile SCSS
        compass:
            app:
                options:
                    noLineComments: false
                    outputStyle: 'expanded'
                    bundleExec: true
            prod:
                options:
                    noLineComments: true
                    outputStyle: 'expanded'
                    bundleExec: true
                    force: true

        ## Compile coffeescript
        coffee:
            config:
                options:
                    bare: true
                files: [
                    expand: true
                    cwd: 'public/coffee'
                    src: ['config.coffee']
                    dest: 'public/assets/scripts'
                    ext: '.js'
                ]

            app:
                options:
                    sourceMap: true
                files: [
                    expand: true
                    cwd: 'public/coffee'
                    src: ['*.coffee', '**/*.coffee', '!config.coffee']
                    dest: 'public/assets/scripts/compiled'
                    ext: '.js'
                ]

            modernizr:
                files: [
                    expand: true
                    cwd: 'public/coffee/modernizr'
                    src: ['*.coffee']
                    dest: 'public/assets/scripts/compiled/modernizr'
                    ext: '.js'
                ]

        removelogging:
            files:
                expand: true
                cwd: 'public/assets/scripts'
                src: ['**/*.js']
                dest: 'public/assets/scripts'
                ext: '.js'

        ## Optimize the requirejs project
        ## https://github.com/jrburke/r.js/blob/master/build/example.build.js
        requirejs:
            main:
                options:
                    optimise: "uglify2"
                    logLevel: 1
                    mainConfigFile: "public/assets/scripts/config.js"
                    baseUrl: "./public/assets/scripts"
                    name: "almond",
                    include: "main",
                    out: "public/assets/scripts/compiled/rjsbuild/main.js",
                    wrap: true
            admin:
                options:
                    optimise: "uglify2"
                    logLevel: 1
                    mainConfigFile: "public/assets/scripts/config.js"
                    baseUrl: "./public/assets/scripts"
                    name: "almond",
                    include: "admin",
                    out: "public/assets/scripts/compiled/rjsbuild/admin.js",
                    wrap: true

            css:
                options:
                    optimizeCss: 'standard'
                    appDir: "public/assets/stylesheets"
                    dir: "public/assets/stylesheets-built"

        copy:
            builtcss:
                files: [
                    {
                        expand: true
                        cwd: 'public/assets/stylesheets-built'
                        src: ['**']
                        dest: 'public/assets/stylesheets/'
                    }
                ]


        ## Optimize images
        imagemin:
            app:
                options:
                    optimizationLevel: 10

                files:[
                    {
                        expand: true
                        cwd: 'public/assets/images'
                        src: ['**/*.{png,jpg}']
                        dest: 'public/assets/images'
                    }
                ]

        parallel:
            default:
                tasks: [
                    {
                        grunt: true
                        args: ['bundle' ,'compass:app']
                    },
                    {
                        grunt: true
                        args: ['coffee:app']
                    },
                    {
                        grunt: true
                        args: ['modernizr']
                    },
                    {
                        grunt: true
                        args: 'bower'
                    }
                ]

            build_js:
                tasks: [
                    {
                        grunt: true
                        args: ['coffee:prod']
                    },
                    {
                        grunt: true
                        args: 'bower'
                    }
                ]

            assetsDev:
                tasks: [
                    {
                        grunt: true
                        args: ['compass:app']
                    },
                    {
                        grunt: true
                        args: ['coffee:app']
                    }
                ]

        bowerrjs:
            target:
                rjsConfig: 'public/assets/scripts/config.js'
                options:
                    baseUrl: 'public'

        bower_install:
            install:
                options:
                    targetDir: 'public/assets/bower_components'
                    cleanTargetDir: true
                    layout: "byComponent"

        clean:
            ## Deletes all files that do not need to be in the Heroku slug
            slug:
                src: ['node_modules', 'public/assets/stylesheets-built', 'public/sass', 'public/coffee', 'ruby', 'vendor/bundle', 'vendor/cache', 'vendor/ruby-2.0.0']
            app:
                src: ['node_modules', 'public/bower_components', 'vendor', 'bootstrap/compiled.php', 'composer.lock', 'public/assets/stylesheets/compiled', 'public/assets/scripts/compiled', 'public/assets/images/generated']


    #########################################
    ## Compile individual coffeescript files

    changedCoffee = Object.create null

    onChange = grunt.util._.debounce () ->
        console.log 'changed', changedCoffee
        ## Should only be ran for coffee in coffee
        ## Get all the changed files stripping coffee/ form the start

        pattern = (src.substr('public/coffee/'.length) for src in Object.keys(changedCoffee))
        compileMap = grunt.file.expandMapping pattern, 'public/assets/scripts/compiled',
            cwd : 'public/coffee'
            ext: '.js'

        grunt.config ['coffee', 'app', 'files'],  compileMap
        changedCoffee = Object.create null
    , 200

    grunt.event.on 'watch', (action, filepath) ->
        coffeeWatchFiles = grunt.config.get ['watch', 'coffee', 'files']
        if grunt.file.isMatch coffeeWatchFiles, filepath
            changedCoffee[filepath] = action
            onChange()

    #########################################

    grunt.loadNpmTasks 'grunt-contrib-compass'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-requirejs'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-notify'
    grunt.loadNpmTasks 'grunt-parallel'
    grunt.loadNpmTasks 'grunt-remove-logging'
    grunt.loadNpmTasks 'grunt-contrib-imagemin'
    grunt.loadNpmTasks 'grunt-modernizr'
    grunt.loadNpmTasks 'grunt-shell'
    grunt.loadNpmTasks 'grunt-phplint'
    grunt.loadNpmTasks 'grunt-phpunit'

    grunt.loadNpmTasks 'grunt-bower-requirejs'
    grunt.renameTask 'bower', 'bowerrjs'

    grunt.loadNpmTasks 'grunt-bower-task'
    grunt.renameTask 'bower', 'bower_install'

    grunt.registerTask 'bower', 'Install and wire up bower', () ->
        grunt.option 'force', true
        grunt.task.run ['bower_install', 'coffee:config', 'bowerrjs']

    grunt.registerTask 'default', [ 'composer', 'parallel:default']

    grunt.registerTask 'modernizr_build', 'Compile modernizr tests and build modernizr', ['coffee:modernizr', 'modernizr']

    grunt.registerTask 'clean-app', 'Cleans compiled files, and installed dependencies', ['clean:app']

    grunt.registerTask 'test', ['phplint', 'phpunit']

    grunt.registerTask 'compile', ['parallel:assetsDev']

    grunt.registerTask 'bundle', 'Install ruby gem dependencies', ['shell:bundle']
    grunt.registerTask 'composer', 'Install composer dependencies', ['shell:composer']

    ## The heroku task is triggered from the buildpack.
    ## And runs on every build
    grunt.registerTask 'heroku', ['compass:prod', 'coffee:app', 'modernizr_build', 'bower', 'compass:app']

    ## Can optionally be called from the PHP command heroku:compile depeending on enviroment
    grunt.registerTask 'build-production', ['removelogging', 'requirejs', 'copy:builtcss', 'clean:slug']
