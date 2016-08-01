var path = require('path')
// webpack.config.js
module.exports = {

  entry: './src/index.ls',
  output: {
	  path:'../public/js',
    filename: 'app.js'
  },
  module: {
    loaders: [
      { test: /\.ls$/, loader: 'livescript-loader', exclude: [/node_modules/] },
      { test: /\.json$/, loader: 'json-loader' },
	//   {
	// 	test: /\.purs$/,
	// 	loader: 'purs-loader',
	// 	exclude: /node_modules/,
	// 	query: {
	// 	  psc: 'psa',
	// 	  src: ['node_modules/purescript-*/src/**/*.purs', 'src/**/*.purs']
	// 	}
	// 	}
    ]
  },
  resolve: {
	  root: path.resolve( __dirname),
    // add alias for application code directory
    alias:{
      client: 'src'
    },
    extensions: [ '', '.js','.ls', '.json' ]
  }
};
