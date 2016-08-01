m = require 'mithril'

const Card = {}

Card.controller = (args)->


Card.view = (ctrl, args)->
	m("div.demo-card-square.mdl-card.mdl-shadow--2dp", [
		m("div.mdl-card__title.mdl-card--expand", [
			m("h2.mdl-card__title-text", args.title)
		])
		m("div.mdl-card__supporting-text", args.content),
			m("div.mdl-card__actions.mdl-card--border", args.actions)
	])

module.exports = Card
