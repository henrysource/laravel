module.exports = (grunt) =>
	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		asciify:
			name:
				text: '<%= pkg.name %>'
				options:
					font:'colossal'
					log:true
		
		php:
			dist:
				options:
					keepalive: true
					open: true
					port: 8000
					base: 'public'

		shell:
			server:
				command: 'php -S localhost:8000'
				options:
					stderr: true
					execOptions:
						cwd: 'public'

			bundle:
				command: 'bundle install'
				options:
					stdout: true

			bower_cache:
				command: 'bower cache-clean'
				options:
					stdout: true

			bower_install:
				command: 'bower install'
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

			open_finder:
				command: "open . &"
				options:
					stdout: true

			open_sublime:
				command: "subl . &"
				options:
					stdout: true

			open_tower:
				command: "gittower . &"
				options:
					stdout: true

			open_site:
				command: "open http://localhost:8000"
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

		## Bower, for front end dependencies
		bower_copy:
			install:
				options:
					install: false
					targetDir: './public/assets/scripts/components'


		modernizr:
			devFile: "remote"
			outputFile: "public/assets/scripts/modernizr.js"
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
				files: 'package.json'
				tasks: 'shell:npm_install'
				
			sass:
				## Compile SCSS when scss or sass file are modified, or items in the sprites directory are modified
				files: ['src/sass/**/*.{scss,sass}','public/assets/images/sprites/**/*.png','public/assets/fonts/**/*']
				tasks: ['compass:app', 'notify:compass']

			coffee:
				files: ['src/coffee/**/*.coffee','!src/coffee/config.coffee']
				options:
					nospawn: true

			coffee_config:
				files: ['src/coffee/config.coffee']
				tasks: ['coffee:config', 'bowerrjs']

			bower:
				files: 'bower.json'
				tasks: ['bower', 'bowerrjs']

			composer:
				files: 'src/composer.json'
				tasks: ['shell:composer']

			modernizr:
				files: ['public/assets/scripts/compiled/modernizr/*']
				tasks: ['modernizr']

		## Compile SCSS
		compass:
			prod:
				options:
					noLineComments: true
					outputStyle: 'compressed'
					force: true

			app:
				options:
					noLineComments: false
					outputStyle: 'expanded'

		## Compile coffeescript
		coffee:
			## Config copied by a watch task and used to compile only changed files
			watch:
				options:
					sourceMap: true
				files: [
					expand: true
					cwd: 'src/coffee/'
					src: ''
					dest: 'public/assets/scripts/compiled'
					ext: '.js'
				]

			config:
				options:
					bare: true
				files: [
					expand: true
					cwd: 'src/coffee'
					src: ['config.coffee']
					dest: 'public/assets/scripts/compiled'
					ext: '.js'
				]

			app:
				options:
					sourceMap: true
				files: [
					expand: true
					cwd: 'src/coffee'
					src: ['**/*.{png,jpg}', '!config.coffee']
					dest: 'public/assets/scripts/compiled'
					ext: '.js'
				]

			prod:
				files: [
					expand: true
					cwd: 'src/coffee'
					src: ['*.coffee', '**/*.coffee', '!config.coffee']
					dest: 'public/assets/scripts/compiled'
					ext: '.js'
				]

		removelogging:
			files:
				expand: true
				cwd: 'app'
				src: ['**/*.js']
				dest: 'app'
				ext: '.js'

		## Optimize the requirejs project
		## https://github.com/jrburke/r.js/blob/master/build/example.build.js
		requirejs:
			compile:
				options:
					optimise: "uglify2"
					logLevel: 1
					appDir: "public"
					dir: "public-build"
					mainConfigFile: "public/assets/scripts/compiled/config.js"
					baseUrl: "assets/scripts"
					
		## Optimize images
		imagemin:
			dynamic_mappings:
				options:
					optimizationLevel: 10

				files:[
					expand: true
					cwd: 'public/assets/images'
					src: ['**/*.{png,jpg}']
					dest: 'public/assets/images'
				]

		parallel:
			default:
				tasks: [
					{
						grunt: true
						args: ['composer']
					},
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

			build:
				tasks: [
					{
						grunt: true
						args: ['compass:prod']
					},
					{
						grunt: true
						args: ['parallel:build_js', 'removelogging']
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

			open:
				tasks: [
					{
						grunt: true
						args: ['shell:open_site']
					},
					{
						grunt: true
						args: ['shell:open_sublime']
					},
					{
						grunt: true
						args: ['shell:open_finder']
					},
					{
						grunt: true
						args: ['shell:open_tower']
					}
				]

		compress:
			build:
				options:
					archive: '<%= pkg.name.toLowerCase() %>.zip'
				files: [
					{
						expand: true
						cwd: 'app-build/'
						src: ['**/*']
						dest: '../'
					},
					{
						expand: true
						dot: true
						cwd: 'app-build/'
						src: 'htdocs/.htaccess'
						dest: '../'
					}
				]

		bowerrjs:
			target:
				rjsConfig: 'public/assets/scripts/compiled/config.js'


	## Compile individual files
	path = require('path')
	grunt.event.on 'watch', (action, filepath) ->
		fileextension = path.extname filepath

		tasks =
			".coffee" 	: 'coffee'

		if action is 'changed' && tasks[fileextension]?
			taskname = tasks[fileextension]
			config = grunt.config taskname

			##Create new task config to compile this file
			if !config[filepath]
				## Copy the dummy watch task defined in taskname:watch
				config[filepath] = JSON.parse JSON.stringify config.watch
				## Set the file path
				config[filepath].files[0].src = filepath.substr(config[filepath].files[0].cwd.length)
				## Update the config
				grunt.config.set taskname, config

			## Run the new or preexisting task for this file path
			grunt.task.run [ "#{taskname}:#{filepath}" ]


	grunt.loadNpmTasks 'grunt-bower-requirejs'
	grunt.renameTask 'bower', 'bowerrjs'

	grunt.loadNpmTasks 'grunt-bower-task'
	grunt.renameTask 'bower', 'bower_copy'

	grunt.registerTask 'bower', 'Install and wire up bower', () ->
		## always use force when watching
		grunt.option 'force', true
		grunt.task.run ['shell:bower_install', 'bower_copy', 'coffee:config', 'bowerrjs']


	grunt.loadNpmTasks 'grunt-contrib-compass'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-requirejs'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-notify'
	grunt.loadNpmTasks 'grunt-parallel'
	grunt.loadNpmTasks 'grunt-remove-logging'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	grunt.loadNpmTasks 'grunt-modernizr'
	grunt.loadNpmTasks 'grunt-shell'
	grunt.loadNpmTasks 'grunt-php'

	grunt.registerTask 'default', ['parallel:default']

	grunt.registerTask 'build', ['parallel:build', 'requirejs']
	grunt.registerTask 'heroku', 'build'

	grunt.registerTask 'cdn', ['build', 'cloudfiles:prod']
	
	grunt.registerTask 'compile', ['parallel:assetsDev']

	grunt.registerTask 'bundle', 'Install ruby gem dependencies', ['shell:bundle']
	grunt.registerTask 'composer', 'Install composer dependencies', ['shell:composer']

	grunt.registerTask 'server', 'Start a server', ['shell:server']

	grunt.registerTask 'open', 'Open the project in the finder, browser and Sublime', () ->
		grunt.task.run 'parallel:open'


	grunt.task.run 'notify_hooks'

