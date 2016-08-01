var path = require('path')
var nodeExternals = require('webpack-node-externals');
module.exports = {
    entry:'./modules/contracts/BlockData.ls',
    output: {
        path: './modules/contracts/',
        filename: 'BlockData.js'
    },
    node: {
        __dirname: false,
        __filename: false,
    },
    target: 'node',
    externals: [nodeExternals()],
    module: {
        loaders: [
            { test: /\.ls$/, loader: 'livescript-loader', exclude: [/node_modules/] },
			{
				test: /\.purs$/,
				loader: 'purs-loader',
				exclude: /node_modules/,
				query: {
				  psc: 'psa',
				  src: ['node_modules/purescript-*/src/**/*.purs', 'src/**/*.purs']
				}
			  }
        ]
    },
    resolve: {
        // root: path.resolve(__dirname),
        // alias: {
        //     client: 'client/src',
        //     shared: 'shared',
        //     server: 'server/src'
        // },
        extensions: ['', '.js', '.ls']
    }
};
