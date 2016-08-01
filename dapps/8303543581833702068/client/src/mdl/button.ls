
m = require 'mithril'

const Button = (opts = {})->
	m 'button.mdl-button.mdl-js-button.mdl-button--raised.mdl-button--accent', {onclick: opts.onclick} ,[
		opts.text
	]


module.exports = Button
