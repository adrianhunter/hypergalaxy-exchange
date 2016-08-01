m = require \mithril
const Home = {}

const Header = require 'client/components/header'
const Markets = require 'client/components/markets'
const Exchange = require 'client/components/exchange'
const AccountsForm = require 'client/components/accounts-form'
const Balance = require 'client/components/balance'
const CreateTokenComp = require 'client/components/create-token'

Home.view = ->
    m '.demo-layout-transparent.mdl-layout.mdl-js-layout.mdl-layout--fixed-header', [
        Header
        m.component CreateTokenComp
        m.component Balance
        m.component AccountsForm
        m.component Markets
        m.component Exchange
    ]

module.exports = Home
