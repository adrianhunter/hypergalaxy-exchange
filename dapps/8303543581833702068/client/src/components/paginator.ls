m = require 'mithril'

const Button = require 'client/mdl/button'

const Paginator = ({total, limit, skip, path})->
	[1 to (Math.ceil total/limit)].map (page)->
		Button {
			text: page
			onclick: ->
				m.route path, page:page

		}




module.exports = Paginator
