/* eslint valid-jsdoc: "off" */

'use strict';
const path = require('path');
/**
 * @param {Egg.EggAppInfo} appInfo app info
 */
module.exports = appInfo => {
  /**
   * built-in config
   * @type {Egg.EggAppConfig}
   **/
  const config = exports = {};

  // use for cookie sign key, should change to your own and keep security
  config.keys = appInfo.name + '_1572945679192_1505';

  // add your middleware config here
  config.middleware = [
    'verifyAT',
    'catchThrowError',
    'checkReponse',
    'locals'
  ];

  config.static = {
    prefix: '/public/',
    dir: path.join(appInfo.baseDir, 'app/public/')
  };

  config.reactssr = {
    layout: path.join(appInfo.baseDir, 'app/web/view/layout.html'),
    renderOptions: {
      basedir: path.join(appInfo.baseDir, 'app/view')
    }
  };

  config.verifyAT = {
    noAccessAPIs: [ '/v1/user', '/web', '/public' ]
  };

  config.security = {
    csrf: {
      enable: false
    },
    domainWhiteList: [ '*' ]
  };
  
  config.cors = {
    origin: '*',
    allowMethods: 'GET,HEAD,PUT,POST,DELETE,PATCH,OPTIONS'
  };
  // add your user config here
  const userConfig = {
    // myAppName: 'egg',
  };

  return {
    ...config,
    ...userConfig
  };
};
