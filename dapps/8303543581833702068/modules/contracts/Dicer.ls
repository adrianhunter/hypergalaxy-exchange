privateFoo = {}
self = null
library = null
modules = null

function BlockData(cb, _library)
  self := this
  self.type := 6
  library := _library
  cb null, self
  return

BlockData::create = (data, trs) ->
  trs.asset =
    deviceId: new Buffer(data.deviceId, 'utf8').toString('hex')
    deviceName: new Buffer(data.deviceName, 'utf8').toString('hex')
    temperature: new Buffer(data.temperature, 'utf8').toString('hex')
    power: new Buffer(data.power, 'utf8').toString('hex')
    gas: new Buffer(data.gas, 'utf8').toString('hex')
    clock: new Buffer(data.clock, 'utf8').toString('hex')
  trs

BlockData::calculateFee = (trs) ->
  0
  # Free!

BlockData::verify = (trs, sender, cb, scope) ->

  setImmediate cb, null, trs
  return

BlockData::getBytes = (trs) ->
  b = Buffer.concat([
    new Buffer(trs.asset.deviceId, 'hex')
    new Buffer(trs.asset.deviceName, 'hex')
    new Buffer(trs.asset.temperature, 'hex')
    new Buffer(trs.asset.power, 'hex')
    new Buffer(trs.asset.gas, 'hex')
    new Buffer(trs.asset.clock, 'hex')
  ])
  b

BlockData::apply = (trs, sender, cb, scope) ->
  modules.blockchain.accounts.mergeAccountAndGet {
    address: sender.address
    balance: -trs.fee
  }, cb
  return

BlockData::undo = (trs, sender, cb, scope) ->
  modules.blockchain.accounts.undoMerging {
    address: sender.address
    balance: -trs.fee
  }, cb
  return

BlockData::applyUnconfirmed = (trs, sender, cb, scope) ->
  if sender.u_balance < trs.fee
    return setImmediate(cb, 'Sender doesn\'t have enough coins')
  modules.blockchain.accounts.mergeAccountAndGet {
    address: sender.address
    u_balance: -trs.fee
  }, cb
  return

BlockData::undoUnconfirmed = (trs, sender, cb, scope) ->
  modules.blockchain.accounts.undoMerging {
    address: sender.address
    u_balance: -trs.fee
  }, cb
  return

BlockData::ready = (trs, sender, cb, scope) ->
  setImmediate cb
  return

BlockData::save = (trs, cb) ->
  modules.api.sql.insert {
    table: 'asset_values'
    values:
      transactionId: trs.id
      deviceId: trs.asset.deviceId
      deviceName: trs.asset.deviceName
      temperature: trs.asset.temperature
      power: trs.asset.power
      gas: trs.asset.gas
      clock: trs.asset.clock
  }, cb
  return

BlockData::dbRead = (row) ->
  if !row.bd_transactionId
    null
  else
    {
      deviceId: row.bd_deviceId
      deviceName: row.bd_deviceName
      temperature: row.bd_temperature
      power: row.bd_power
      gas: row.bd_gas
      clock: row.bd_clock
    }

BlockData::normalize = (asset, cb) ->
  library.validator.validate asset, {
    type: 'object'
    properties:
      deviceId:
        type: 'string'
        format: 'hex'
        minLength: 1
      deviceName:
        type: 'string'
        format: 'hex'
        minLength: 1
      temperature:
        type: 'string'
        format: 'hex'
        minLength: 1
      power:
        type: 'string'
        format: 'hex'
        minLength: 1
      gas:
        type: 'string'
        format: 'hex'
        minLength: 1
      clock:
        type: 'string'
        format: 'hex'
        minLength: 1
    required: [
      'deviceId'
      'deviceName'
      'temperature'
      'power'
      'gas'
      'clock'
    ]
  }, cb
  return

BlockData::onBind = (_modules) ->
  modules = _modules
  modules.logic.transaction.attachAssetType self.type, self
  return

BlockData::putValues = (cb, query) ->
  library.validator.validate query, {
    type: 'object'
    properties:
      secret:
        type: 'string'
        minLength: 1
        maxLength: 100
      deviceId:
        type: 'string'
        minLength: 1
        maxLength: 42
      deviceName:
        type: 'string'
        minLength: 1
        maxLength: 42
      temperature:
        type: 'string'
        minLength: 1
        maxLength: 42
      power:
        type: 'string'
        minLength: 1
        maxLength: 42
      gas:
        type: 'string'
        minLength: 1
        maxLength: 42
      clock:
        type: 'string'
        minLength: 1
        maxLength: 42
  }, (err) ->
    # If error exists, execute callback with error as first argument
    if err
      return cb(err[0].message)
    keypair = modules.api.crypto.keypair(query.secret)
    modules.blockchain.accounts.setAccountAndGet { publicKey: keypair.publicKey.toString('hex') }, (err, account) ->
      # If error occurs, call cb with error argument
      if err
        return cb(err)
      console.log account
      try
        transaction = library.modules.logic.transaction.create(
          type: self.type
          deviceId: query.deviceId
          deviceName: query.deviceName
          temperature: query.temperature
          power: query.power
          gas: query.gas
          clock: query.clock
          sender: account
          keypair: keypair)
      catch e
        # Catch error if something goes wrong
        return setImmediate(cb, e.toString())
      # Send transaction for processing
      modules.blockchain.transactions.processUnconfirmedTransaction transaction, cb
      return
    return
  return

BlockData::getValues = (cb, query) ->
  # Verify query parameters
  library.validator.validate query, {
    type: 'object'
    properties: deviceId:
      type: 'string'
      minLength: 1
      maxLength: 42
    required: [ 'deviceId' ]
  }, (err) ->
    if err
      return cb(err[0].message)
    # Select from transactions table and join entries from the asset_values table
    modules.api.sql.select {
      table: 'transactions'
      alias: 't'
      condition:
        deviceId: query.deviceId
        type: self.type
      join: [ {
        type: 'left outer'
        table: 'asset_values'
        alias: 'bd'
        on: 't.id': 'bd.transactionId'
      } ]
    }, [
      'id'
      'type'
      'senderId'
      'senderPublicKey'
      'recipientId'
      'amount'
      'fee'
      'signature'
      'blockId'
      'transactionId'
      'deviceId'
      'deviceName'
      'temperature'
      'power'
      'gas'
      'clock'
    ], (err, transactions) ->
      if err
        return cb(err.toString())
      # Map results to asset object
      homeValues = transactions.map((tx) ->
        tx.asset =
          deviceId: new Buffer(tx.deviceId, 'hex').toString('utf8')
          deviceName: new Buffer(tx.deviceName, 'hex').toString('utf8')
          temperature: new Buffer(tx.temperature, 'hex').toString('utf8')
          power: new Buffer(tx.power, 'hex').toString('utf8')
          gas: new Buffer(tx.gas, 'hex').toString('utf8')
          clock: new Buffer(tx.clock, 'hex').toString('utf8')
        delete tx.deviceId
        delete tx.deviceName
        delete tx.temperature
        delete tx.power
        delete tx.gas
        delete tx.clock
        tx
      )
      cb null, homeValues: homeValues
    return
  return

module.exports = BlockData

# ---
# generated by js2coffee 2.2.0
