m = require 'mithril'

const AccountsForm = require 'client/components/accounts-form'


const AccountsView = {}

AccountsView.view = (ctrl, args = {})->
	m '.demo-layout-transparent.mdl-layout.mdl-js-layout.mdl-layout--fixed-header', [
		m.component AccountsForm, {
			mode: args.mode
		}
	]

module.exports = AccountsView
