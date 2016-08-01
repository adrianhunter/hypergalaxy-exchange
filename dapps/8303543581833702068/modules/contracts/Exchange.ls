privateFoo = {}



class Exchange
    self = null
    library = null
    modules = null
    (cb, _library)->
        self := this
        self.type := 7
        library := _library
        cb null, self

    create:(data, trs)->
        trs.asset =
            sell_token: data.sell_token
            buy_token: data.buy_token
            price: data.price
            amount: data.amount
        trs
        /*trs.asset =
            sell_token: new Buffer(data.sell_token, 'utf8').toString('hex')
            buy_token: new Buffer(data.buy_token, 'utf8').toString('hex')
            price: new Buffer(data.price, 'utf8').toString('hex')
            amount: new Buffer(data.amount, 'utf8').toString('hex')
        trs*/

    calculateFee:(trs)-> 0
    verify:(trs, sender, cb, scope)!->
        setImmediate cb, null, trs
    getBytes: (trs) ->
        console.log trs

        try
            buf = new Buffer(trs.asset.sell_token + trs.asset.buy_token + trs.asset.price + trs.asset.amount, "utf8")
        catch e
            throw Error(e.toString())

        return buf
        /*Buffer.concat([
            new Buffer(trs.asset.sell_token, 'hex')
            new Buffer(trs.asset.buy_token, 'hex')
            new Buffer(trs.asset.price, 'hex')
            new Buffer(trs.asset.amount, 'hex')
        ])*/
    apply:(trs, sender, cb, scope) !->
        modules.blockchain.accounts.mergeAccountAndGet {
            address: sender.address
            balance:{LISK: -trs.fee}
        }, cb
    undo:(trs, sender, cb, scope) !->
        modules.blockchain.accounts.undoMerging {
            address: sender.address
            balance:{LISK: -trs.fee}
        }, cb
    applyUnconfirmed:(trs, sender, cb, scope) !->
        if sender.u_balance < trs.fee
            return setImmediate(cb, 'Sender doesn\'t have enough coins')
        modules.blockchain.accounts.mergeAccountAndGet {
            address: sender.address
            u_balance:{LISK: -trs.fee}
        }, cb

    undoUnconfirmed:(trs, sender, cb, scope)!->
        modules.blockchain.accounts.undoMerging {
            address: sender.address
            u_balance:{LISK: -trs.fee}
        }, cb

    ready:(trs, sender, cb, scope)!-> setImmediate cb

    save:(trs, cb)!->
        console.log 'saving!!!', trs
        modules.api.sql.insert {
            table: 'asset_buy_orders'
            values:
                transactionId: trs.id
                sell_token: trs.asset.sell_token
                buy_token: trs.asset.buy_token
                price: trs.asset.price
                amount: trs.asset.amount
        }, cb
    dbRead:(row) ->
        if !row.buys_transactionId
            null
        else
            {
                sell_token: row.buy_sell_token
                buy_token: row.buy_buy_token
                price: row.buy_price
                amount: row.buy_amount
            }
    normalize:(asset, cb) ->

        return setImmediate(cb)

        library.validator.validate asset, {
            type: 'object'
            properties:
                sell_token:
                    type: 'string'
                    format: 'hex'
                    minLength: 1
                buy_token:
                    type: 'string'
                    format: 'hex'
                    minLength: 1

            required: [
                'sell_token'
                'buy_token'
            ]
        }, (e,r)->
            console.log e,r
            cb e,r
    onBind:(_modules) ->
        modules := _modules
        modules.logic.transaction.attachAssetType self.type, self

        return
    transfer:(cb, query)!->

        keypair = modules.api.crypto.keypair(query.secret)


        modules.blockchain.accounts.setAccountAndGet { publicKey: keypair.publicKey.toString('hex') }, (err, account) ->


            try
                transaction = library.modules.logic.transaction.create({
                    type: 1,
                    sender: account
                    keypair: keypair
                    recipientId: '14897368726134874721L',
                    amount: 1000000,
                    src_id:'15644840914319835157'
                })
            catch e
                return setImmediate(cb, e.toString())

            modules.blockchain.transactions.processUnconfirmedTransaction(transaction, cb)

    createBuyOrder:(cb, query) ->
        console.log query, 'asldkjhalsjkdh'
        library.validator.validate query, {
            type: 'object'
            properties:
                secret:
                    type: 'string'
                    minLength: 1
                    maxLength: 100
                buy_token:
                    type: 'string'
                    minLength: 1
                    maxLength: 42
                sell_token:
                    type: 'string'
                    minLength: 1
                    maxLength: 42
                price:
                    type: 'integer'
                    minLength: 1
                    maxLength: 42
                amount:
                    type: 'integer'
                    minLength: 1
                    maxLength: 42
        }, (err) ->
            console.log 1111111111111111
            # If error exists, execute callback with error as first argument
            if err
                console.log 2222222222222

                console.log err
                return cb(err[0].message)

            keypair = modules.api.crypto.keypair(query.secret)
            modules.blockchain.accounts.setAccountAndGet { publicKey: keypair.publicKey.toString('hex') }, (err, account) ->
                # If error occurs, call cb with error argument
                if err
                    console.log 333333333333
                    return cb(err)
                console.log {
                    type: self.type
                    sell_token: query.sell_token
                    buy_token: query.buy_token
                    amount: query.amount
                    price: query.price
                    sender: account
                    keypair: keypair
                }
                console.log 999999999999
                try
                    transaction = library.modules.logic.transaction.create({
                        type: self.type
                        sell_token: query.sell_token
                        buy_token: query.buy_token
                        price: query.price
                        amount: query.amount
                        sender: account
                        keypair: keypair
                    })
                catch e
                    console.log 4444444444
                    # Catch error if something goes wrong
                    return setImmediate(cb, e.toString())
                # Send transaction for processing
                modules.blockchain.transactions.processUnconfirmedTransaction transaction, cb
                return
            return
        return
    hyper:(cb, query)!->

        modules.blockchain.accounts.getAccount {address: '14897368726134874721L'}, (e,r)->


            console.log(query)
            cb e, r

    getPublicAccounts:(cb, query)->

    getBuyWall:(cb)->
        modules.api.sql.select {
            table: 'asset_buy_orders'
        }, null, (err, transactions) ->
            if err
                return cb(err.toString())
            # Map results to asset object
            console.log transactions
            homeValues = transactions.map((tx) ->
                tx
            )
            cb null, homeValues: homeValues



module.exports = Exchange
