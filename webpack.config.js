'use strict';
const path = require('path');
const resolve = filepath => path.resolve(__dirname, filepath);
module.exports = {
  // target: 'web',
  entry: {
    home: 'app/web/page/home/index.js'
  },
  loaders: {
    babel: {
      include: [ resolve('app/web'), resolve('node_modules') ]
    },
    less: {
      include: [ resolve('app/web'), resolve('node_modules') ],
      options: {
        javascriptEnabled: true,
        modifyVars: {
          'primary-color': 'red',
          'link-color': '#1DA57A',
          'border-radius-base': '2px'
        }
      }
    }
  },
  resolve: {
    // 设置别名
    alias: {
      '@web': resolve('app/web'),
      '@webFramework': resolve('app/web/framework'),
      '@webComp': resolve('app/web/component'),
      '@webPage': resolve('app/web/page'),
      '@webApi': resolve('app/web/api'),
      '@webUtil': resolve('app/web/util'),
      '@webConfig': resolve('app/web/config')
    }
  }
};
