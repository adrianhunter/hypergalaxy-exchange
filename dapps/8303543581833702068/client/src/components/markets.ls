m = require 'mithril'
const Markets = {}
const Table = require 'client/mdl/table'


Markets.controller = (args)->

    {
        markets:m.request({
            method: "GET"
            unwrapSuccess: (r)->
                r.response.tokens
            url: "#{App.api_url}/tokens/get"
            })
    }

Markets.view = (ctrl, args)->


    rows = _.map ctrl.markets(), (market)->
        m 'tr', [
            m 'td', market.tiker
            m 'td', market.name
        ]

    tableHead = [
        m 'th', 'foo'
    ]


    m '.markets', [
        'Markets'
        m.component Table, {
            rows: rows
            head: tableHead

        }



    ]

module.exports = Markets
