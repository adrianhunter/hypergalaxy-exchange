m = require \mithril
const Card = require 'client/mdl/card'
const Header = require 'client/components/header'
const AdminComp = {}
const Table = require 'client/mdl/table'
const AdminTable = require 'client/components/admin-table'
const _ = require 'underscore'
const config = {
	services:
		translations: {}
		users: {}
}

AdminComp.controller = (args)->

AdminComp.view = (ctrl, args = {})->
	m '.demo-layout-transparent.mdl-layout.mdl-js-layout.mdl-layout--fixed-header.mdl-layout--fixed-drawer', [
		Header

		m '.mdl-layout__drawer', [
			m 'span.mdl-layout-title', 'Services'
			m 'nav.mdl-navigation', _.map config.services, (options, service)->
				m 'a.mdl-navigation__link', {href:"/admin/#{service}", config:m.route}, service
		]

		m 'main.mdl-layout__content', [
			m '.page-content', [
				m '.mdl-grid', [
					m.component AdminTable, {
						service: args.params?.service or m.route.param('service')
						result: args.result
					}
				]

			]
		]

	]

module.exports = AdminComp
