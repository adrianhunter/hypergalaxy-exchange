m = require 'mithril'
const TextField = require 'client/mdl/textfield'
const Button = require 'client/mdl/button'
const AccountsForm = {}

styles =
    form: "max-width:300px; margin:auto;"


AccountsForm.controller = (args={})->
    AccountsForm.vm.mode(args.mode or 'login')

    {
    }

AccountsForm.view = (ctrl, args)->
    m '.accounts-form', {style: styles.form},[
        m 'form', [
            TextField key: 'password', type: 'password', label: 'password', bind: AccountsForm.vm.password
            Button text: (AccountsForm.vm.mode!), onclick: submitForm
        ]
    ]

AccountsForm.vm =
    mode: m.prop()
    password: m.prop()
    email: m.prop()

submitForm = (e)!->
    e.preventDefault()
    m.request({method:"GET", url:"#{App.api_url}/openAccount?secret=#{AccountsForm.vm.password()}"}).then (r)->
        console.log r


module.exports = AccountsForm
