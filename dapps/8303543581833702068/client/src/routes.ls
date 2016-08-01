m = require \mithril


routes = [
	{
		name: 'Home'
		path: '/'
		component: require 'client/views/home'
	}

	{
		name: 'register'
		path: '/register'
		component: require 'client/views/accounts'
		args:
			mode: 'register'

	}
	{
		name: 'login'
		path: '/login'
		component: require 'client/views/accounts'
		args:
			mode: 'login'

	}
]


module.exports = routes
