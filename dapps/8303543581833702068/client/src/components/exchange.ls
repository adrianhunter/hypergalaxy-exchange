m = require 'mithril'
const Exchange = {}
const Table = require 'client/mdl/table'
const Card = require 'client/mdl/card'
const Button = require 'client/mdl/button'
const TextField = require 'client/mdl/textfield'

Exchange.controller = (args)->

    {

    }

Exchange.view = (ctrl, args)->


    m '.exchange', [
        m.component Card, {
            title: 'buy hyper'
            content: [
                m 'form', [
                    TextField key: 'price', label: 'price', bind: VM.buy.price
                    TextField key: 'amount', type: 'amount', label: 'amount', bind: VM.buy.amount
                    TextField key: 'total', type: 'total', label: 'total', bind: VM.buy.total, val: VM.buy.price()*VM.buy.amount()
                ]
            ]
            actions: [
                Button {text: 'Buy',onclick:handleBuy}
            ]
        }


    ]

Exchange.vm =
    buy:
        token: m.prop()
        price: m.prop(0)
        amount: m.prop(0)
        total: -> console.log 'total!!'

handleBuy = ->

    query = "?secret=#{Account.secret}&buy_token=#{VM.buy.token()}&sell_token=LISK&amount=#{VM.buy.amount()}&price=#{VM.buy.price()}"

    request = {
        method: 'GET'
        url: "#{App.api_url}/exchange/buyorder" + query
        /*query:
            recipientId: "13933155277692406562L"
            secret: "obey east curtain shallow erase refuse feature lake cereal lesson road glad"
            amount: CreateTokenComp.vm.amount()
            token: "LISK"*/
        }

    m.request(request).then (r)->
            console.log r


VM = Exchange.vm

window.Exchange = Exchange

module.exports = Exchange
