import Router from './router'

if module.hot
    module.hot.accept()

if process.env.NODE_ENV == 'production'
	offline = require 'offline-plugin/runtime'
	offline.install
		onUpdateReady: =>
			offline.applyUpdate()
		onUpdated: =>
			window.location.reload()

Inferno.render(
    <Router />,
    document.getElementById('container')
)