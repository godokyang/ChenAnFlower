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
  ];

  config.static = {
    prefix: '/public/',
    dir: path.join(appInfo.baseDir, '/app/public/'),
  };

  config.verifyAT = {
    noAccessAPIs: [ '/user/loginOrRegister' ],
  };
  // add your user config here
  const userConfig = {
    // myAppName: 'egg',
  };

  return {
    ...config,
    ...userConfig,
  };
};
