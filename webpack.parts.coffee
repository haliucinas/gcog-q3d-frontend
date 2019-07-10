webpack = require('webpack')
HtmlWebpackPlugin = require('html-webpack-plugin')
{ CleanWebpackPlugin } = require('clean-webpack-plugin')
MiniCssExtractPlugin = require('mini-css-extract-plugin')
CompressionPlugin = require('compression-webpack-plugin')
OfflinePlugin = require('offline-plugin')

exports.index = (mode, options) =>
    plugins: [
        new HtmlWebpackPlugin(
            appMountId: options.appMountId
            title: options.title
            template: options.template
            favicon: options.favicon
            meta: options.meta
            inject: false
            mobile: true
            minify: {
                'production':
                    removeAttributeQuotes: true
                    collapseWhitespace: true
                    html5: true
                    minifyCSS: true
                    removeComments: true
                    removeEmptyAttributes: true
                'development':
                    false
            }[mode]
            hash: true
            cache: true
        )
    ]

exports.devServer = (options) =>
    resolve: {
        alias: {
            'inferno': 'inferno/dist/index.dev.esm.js'
        }
    }
    devServer:
        stats: 'errors-only'
        host: options.host
        port: options.port
        hot: true
        inline: true
        disableHostCheck: true
        overlay:
            errors: true
            warnings: true
        watchOptions:
            aggregateTimeout: 300
            poll: options.poll or 1000
    plugins: [
        new webpack.HotModuleReplacementPlugin()
        new webpack.WatchIgnorePlugin([options.node_modules])
    ]

exports.splitChunks = (options) =>
    optimization:
        splitChunks:
            cacheGroups:
                commons:
                    test: options.node_modules
                    name: 'vendor'
                    chunks: 'all'
        runtimeChunk:
            name: 'manifest'

exports.clean = (paths) =>
    plugins: [
        new CleanWebpackPlugin()
    ]

exports.loadAssets = (paths) =>
    module:
        rules: [
            { test: /\.(png|jpg|gif|svg)$/, loader: 'file-loader', options: {name: 'img/[name].[hash].[ext]' }}
            { test: /\.(eot|ttf|woff|woff2)$/, loader: 'file-loader', options: {name: 'font/[name].[hash].[ext]'}}
        ]

exports.loadStyle = (paths) =>
    module:
        rules: [
            {
                test: /\.css$/
                use: ['style-loader', 'css-loader']
                include: paths
            }   
            {
                test: /\.(scss|sass)$/
                use: ['style-loader', 'css-loader', 'sass-loader']
                include: paths
            }
        ]

exports.loadJSX = (include) =>
    module:
        rules: [
            { test: /\.(cjsx)$/, use: ['babel-loader', 'coffee-loader'] }
            { test: /\.(coffee)$/, use: ['coffee-loader'] }
            { test: /\.(coffee\.md|litcoffee)$/, loader: 'coffee-loader', options: {literate: true}}
        ]

exports.loadConfig = (paths) =>
    module:
        rules: [
            { test: /\.ya?ml$/, loader: 'yaml-import-loader', options: {output: 'object'}, include: paths}
        ]

exports.setFreeVariable = (vars) =>
    plugins: [
        new webpack.DefinePlugin(vars)
    ]

exports.preloadModule = (modules) =>
    plugins: [
        new webpack.ProvidePlugin(modules)
    ]

exports.extractStyle = (paths) =>
    module:
        rules: [
            {
                test: /\.css$/
                use: [
                    MiniCssExtractPlugin.loader
                    'css-loader'
                ]
                include: paths
            }
            {
                test: /\.(scss|sass)$/
                use: [
                    MiniCssExtractPlugin.loader
                    'css-loader'
                    'sass-loader'
                ]
                include: paths
            }
        ]
    plugins: [
        new MiniCssExtractPlugin({
            filename: 'style/[name].[hash].css'
            chunkFilename: 'style/[name].[id].css'
        })
    ]

exports.gzip = =>
    plugins: [
        new CompressionPlugin({
            filename: '[path].gz[query]',
            algorithm: 'gzip',
            test: /\.js$|\.css$|\.svg$|\.eot|\.woff2|\.ttf$/,
            minRatio: 0.75,
            cache: true,
        })
    ]

exports.offline = =>
    plugins: [
        new OfflinePlugin({
            AppCache: false
            ServiceWorker: { events: true }
        })
    ]