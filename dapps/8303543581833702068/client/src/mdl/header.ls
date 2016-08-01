m = require 'mithril'


const Header = {}

Header.controller = (args)->


Header.view = (ctrl, args)->
	m('header.mdl-layout__header', [
		m('.mdl-layout__header-row', [
			m('span.mdl-layout-title', 'Title')
			m('.mdl-layout-spacer')
			m('nav.mdl-navigation', [
				m('a.mdl-navigation__link[href=/admin]',{config:m.route}, 'Admin')
				m('a.mdl-navigation__link[href=]', 'Link')
				m('a.mdl-navigation__link[href=]', 'Link')
				m('a.mdl-navigation__link[href=\'\']', 'Link')
			])
		])
	])


module.exports = Header
