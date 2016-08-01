const m = require 'mithril'


const TextField = ({key, val, bind, label, type})->
    inputSettings =
        type: type or 'text'

    classes = ""

    if val
        inputSettings.value = val
        /*if val?.length*/
    classes += '.is-dirty'
    if bind
        inputSettings.onchange = m.withAttr("value", (e,r)->
            bind(e,r)
        )





    m ".mdl-textfield.mdl-js-textfield.mdl-textfield--floating-label##{key}",{config: configureTextField} ,[
        m "input.mdl-textfield__input", inputSettings ,[

        ]
        m 'label.mdl-textfield__label', {for: key}, label
    ]


configureTextField = (elm, isInit)->
    if !isInit
        componentHandler?.upgradeElements elm


module.exports = TextField
