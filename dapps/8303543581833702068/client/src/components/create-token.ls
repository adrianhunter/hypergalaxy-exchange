m = require 'mithril'
const TextField = require 'client/mdl/textfield'
const Button = require 'client/mdl/button'
const CreateTokenComp = {}


CreateTokenComp.controller = (args={})->
    {

    }

CreateTokenComp.view = (ctrl, args)->
    m '.balance',[
        TextField key: 'name', type: 'name', label: 'name', bind: CreateTokenComp.vm.name
        TextField key: 'description', type: 'description', label: 'description', bind: CreateTokenComp.vm.description
        TextField key: 'fund', type: 'fund', label: 'fund', bind: CreateTokenComp.vm.fund
        Button text: 'Create token', onclick: handleCreateToken
    ]

CreateTokenComp.vm =
    fund: m.prop(0)
    name: m.prop(0)
    description: m.prop(0)

VM = CreateTokenComp.vm

handleCreateToken = ->
    console.log 123

    query = "?recipientId=13933155277692406562L&secret=obey east curtain shallow erase refuse feature lake cereal lesson road glad&fund=#{VM.fund()}&name=#{VM.name()}&description=#{VM.description()}"

    request = {
        method: 'GET'
        url: "#{App.api_url}/token/create" + query
        /*query:
            recipientId: "13933155277692406562L"
            secret: "obey east curtain shallow erase refuse feature lake cereal lesson road glad"
            amount: CreateTokenComp.vm.amount()
            token: "LISK"*/
        }

    m.request(request).then (r)->
            console.log r




module.exports = CreateTokenComp
