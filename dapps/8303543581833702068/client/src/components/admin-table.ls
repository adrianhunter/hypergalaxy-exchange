m = require \mithril

const Table = require 'client/mdl/table'
const _ = require 'underscore'
const AdminTable = {}
const Dialog = require 'client/mdl/dialog'
const TextField = require 'client/mdl/textfield'
const Paginator = require 'client/components/paginator'

styles = {
	admin-table: "width: 100%"

}

AdminTable.controller = (args)->
	console.log args
	service = app.service(args.service)

	scope = {
		data: m.prop([{}])
		result: m.prop([{}])
		service: service
		dialog:
			title: m.prop(args.service or 'none')
			content: m.prop()
			onCancel: (e)->
				console.log e
			onSubmit: (e)->
				console.log e
			show: m.prop(false)
	}


	AdminTable.vm.service args.service

	return scope




AdminTable.view = (ctrl, args)->
	result = ctrl.result()
	dialog = m.component Dialog, ctrl.dialog
	rows = _.map ctrl.data(), (dat)->
		tableData = _.map dat, (val, key)->
			m "td", val
		tableData.push m 'td', [
			m 'button.mdl-button.mdl-js-button.mdl-button--icon', { onclick:handleEdit.bind dat },[
				m 'i.material-icons', 'edit'
			]
			m 'button.mdl-button.mdl-js-button.mdl-button--icon', [
				m 'i.material-icons', 'delete'
			]
		]
		m "tr", tableData

	tableHead = _.map Object.keys(ctrl.data()[0]), (key)->
		m "th", key

	tableHead.push m 'th', 'actions'



	m '.admin-table',{style: styles.admin-table} ,[
		dialog
		m.component Table, {
			style: styles.admin-table
			rows: rows
			head: tableHead

		}
		console.log 43
		m 'button.mdl-button.mdl-js-button.mdl-button--fab.mdl-button--colored', {onclick: handleCreate } [
			m 'i.material-icons', 'add'
		]

	]
/*Paginator {skip: result.skip, limit: result.limit, total: result.total, path:"/admin/#{AdminTable.vm.service!}"}*/

AdminTable.vm = {
	service: m.prop()
	dialog: null
}

function handleEdit(e)
	m.startComputation!
	Dialog.vm.content generateForm @
	Dialog.vm.show!
	m.endComputation!
	return

!function handleCreate()
	m.startComputation!
	Dialog.vm.content generateFormBySchema Schemas[AdminTable.vm.service!]
	Dialog.vm.show!
	m.endComputation!

function generateFormBySchema(schema)
	m 'form', _.map schema,(options, key)-> TextField({key, label:key})


function generateForm(doc)
	m 'form', _.map doc,(key, val)-> TextField(key, val)


module.exports = AdminTable
