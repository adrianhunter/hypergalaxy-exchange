m = require 'mithril'


const Dialog = {}

Dialog.controller = (args)->

Dialog.view = (ctrl, args)->
	m("dialog.mdl-dialog", {config: configureDialog } ,[
		m("h4.mdl-dialog__title", args.title!)
		m(".mdl-dialog__content", [
			m("p", [
				Dialog.vm.content!
			])
		])
		m(".mdl-dialog__actions", [
			m("button.mdl-button[type='button']",{onclick:(e)->
				Dialog.vm.close!
				args.onSubmit(e)
			},"Agree")
			m("button.mdl-button.close[type='button']",{onclick:(e)->
				Dialog.vm.close!
				args.onCancel(e)
			},"Disagree")
		])
	])

configureDialog = (elem, isInit)->
	Dialog.vm.elem = elem

Dialog.vm =
	elem: null
	close:!->
		if @elem
			@elem.close!
	show:!->
		if @elem
			@elem.showModal!
	content: m.prop()

module.exports = Dialog
