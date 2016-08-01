m = require \mithril

const Table = {}

Table.controller = (args)->

Table.view = (ctrl, args)->
    m("table.mdl-data-table.mdl-js-data-table.mdl-data-table--selectable.mdl-shadow--2dp",{config:configureTable, style: args.style}, [
        m("thead", [
            m("tr", args.head)
        ])
        m("tbody", args.rows)
    ])


configureTable = (elm, isInit)->
    if !isInit
        componentHandler?.upgradeElements elm

module.exports = Table
