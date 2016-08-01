m = require \mithril
_ = require 'underscore'
routes = require 'client/routes'


m.route.mode = 'pathname'
window.m = m
window._ = require 'underscore'
window.App =
    api_url: '/api/dapps/8303543581833702068/api'
window.Account =
    secret: "tired finger narrow rapid palm grape choice cube fix vault taste dress"
    address: "14897368726134874721L"


routesObj = {}
_.each routes, (route)->
    route.args ||= {}
    routesObj[route.path] = m.component route.component, route.args


m.route document.body, "/", routesObj
