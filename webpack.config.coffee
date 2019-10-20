path = require('path')
merge = require('webpack-merge')
template = require('html-webpack-template')

parts = require('./webpack.parts')

PATHS =
	app: [
		path.join(__dirname, 'src', 'main.cjsx')
	]
	style: [
		path.join(__dirname, 'assets', 'style', 'main.scss')
		path.join(__dirname, 'node_modules', 'spectre.css', 'dist', 'spectre.min.css')
	]
	fonts: path.join(__dirname, 'assets', 'fonts')
	build: path.join(__dirname, 'build')
	node_modules: path.join(__dirname, 'node_modules')
	template: template

common = (mode) => merge(
	entry:
		style: PATHS.style
		app: PATHS.app
	output:
		path: PATHS.build
		filename: '[name].[hash].js'
		publicPath: '/'
	resolve:
		extensions: ['.js', '.coffee', '.cjsx']
	parts.index(mode, {
		appMountId: 'container'
		title: 'GCOG | Q3A'
		template: PATHS.template
		meta: [{
			name: 'description',
			content: 'GCOG Quake 3 Arena Server'
		}]
	})
	parts.loadAssets([
		PATHS.app
		PATHS.style
		PATHS.fonts
	])
	parts.loadJSX(PATHS.app)
	parts.preloadModule(
		Inferno: 'inferno'
		Component: ['inferno', 'Component']
		Link: ['inferno-router', 'Link']
		NavLink: ['inferno-router', 'NavLink']
		_: 'lodash'
		moment: 'moment'
	)
)

development = merge(
	parts.setFreeVariable({
		'process.env.NODE_ENV': JSON.stringify('development')
	})
	parts.loadStyle([PATHS.style])
	parts.devServer({
		node_modules: PATHS.node_modules
		poll: process.env.ENABLE_POLLING
		host: process.env.HOST
		port: process.env.PORT
	})
)

production = merge(
	output:
		filename: 'js/[name].[hash].js'
		chunkFilename: 'js/[name].[chunkhash].js'
	parts.setFreeVariable({
		'process.env.NODE_ENV': JSON.stringify('production')
	})
	parts.clean([PATHS.build])
	parts.extractStyle([PATHS.style])
	parts.splitChunks({
		node_modules: PATHS.node_modules
	})
	parts.gzip()
	parts.offline()
)

module.exports = (env, argv) =>
	mode = argv.mode
	switch mode
		when 'development'
			merge(common(mode), development, {mode})  
		when 'production'
			merge(common(mode), production, {mode})