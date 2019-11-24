'use strict';

/** @type Egg.EggPlugin */
module.exports = {
  // had enabled by egg
  // static: {
  //   enable: true,
  // }
  mysql: {
    enable: true,
    package: 'egg-mysql'
  },
  reactssr: {
    enable: true,
    package: 'egg-view-react-ssr'
  },
  cors: {
    enable: true,
    package: 'egg-cors'
  }
};
