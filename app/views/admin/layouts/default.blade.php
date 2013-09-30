<!DOCTYPE html>
<!--[if IE 7]>    <html class="ie7 oldie" > <![endif]-->
<!--[if IE 8]>    <html class="ie8 oldie" > <![endif]-->
<html lang="en">
<head>
    <title>Admin</title>
    <meta charset="UTF-8" />

    <!--[if lt IE 9]>
        <script src="//html5shiv.googlecode.com/svn/trunk/html5.js"></script>
        <script>window.html5 || document.write('<script src="js/vendor/html5shiv.js"><\/script>')</script>
    <![endif]-->

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" type="text/css" href="/assets/bower_components/bootstrap/dist/css/bootstrap.css">
    <link rel="stylesheet" type="text/css" href="/assets/stylesheets/compiled/admin.css">
</head>
<body>
    <nav class="navbar navbar-default" role="navigation">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            @if($adminUser)
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
            @endif

            <a class="navbar-brand" href="{{ url('admin') }}">Laravel Bootstrap</a>
        </div>

        @if($adminUser)
            <!-- Collect the nav links, forms, and other content for toggling -->
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                {{ HTML::render_menu(array(
                    array('href' => 'admin/config', 'title' => 'Config'),
                    array('href' => 'admin/users', 'title' => 'Users')
                )) }}

                <ul class="nav navbar-nav navbar-right">
                    <li><a href="/" target="_blank">View Site</a>
                    <li><a href="/admin/logout">Logout</a>
                </ul>
            </div><!-- /.navbar-collapse -->
        @endif
    </nav>

    <div class="container" role="main">
        @yield('content')
    </div>

    <script src="/assets/bower_components/requirejs/require.js"></script>

    @if ('production' != App::environment())
        <script>
            require.config({
                urlArgs: "bust=" + (new Date()).getTime()
            });
        </script>
    @endif

    <script type="text/javascript">
        {{ File::get(public_path().'/assets/scripts/config.js') }}

        requirejs.config({
            baseUrl: '/assets/scripts'
        });

        require(["/assets/scripts/compiled/admin.js"]);
    </script>
</body>
</html>
