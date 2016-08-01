m = require 'mithril'
const TextField = require 'client/mdl/textfield'
const Button = require 'client/mdl/button'
const Balance = {}


Balance.controller = (args={})->
    {

    }

Balance.view = (ctrl, args)->
    m '.balance',[

        TextField key: 'amount', type: 'amount', label: 'amount', bind: Balance.vm.amount
        Button text: 'Deposit', onclick: handleDeposit


    ]

Balance.vm =
    amount: m.prop(0)

handleDeposit = ->
    console.log 123

    query = "?recipientId=13933155277692406562L&secret=obey east curtain shallow erase refuse feature lake cereal lesson road glad&amount=10&token=LISK"

    request = {
        method: 'GET'
        url: "#{App.api_url}/transaction/create" + query
        /*query:
            recipientId: "13933155277692406562L"
            secret: "obey east curtain shallow erase refuse feature lake cereal lesson road glad"
            amount: Balance.vm.amount()
            token: "LISK"*/
        }

    m.request(request).then (r)->
            console.log r




module.exports = Balance
