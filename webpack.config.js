const path = require('path');

module.exports = {
  mode: 'development',
  entry: './src/index.js',
  devtool: 'eval-source-map',
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist'),
  },
  module: {
    rules: [
      {
        test: /\.(png|svg|jpg|gif)$/,
        use: [ 'file-loader' ]
      },
      {
        test: /\.glsl$/,
        use: [ 'webpack-glsl-loader' ]
      },
      {
        test: /\.html$/i,
        loader: 'html-loader',
      },
      {
        test: /\.js$/,
        enforce: 'pre',
        use: ['source-map-loader'],
      },
    ]
  }
};