'use strict';

module.exports = appinfo => {
  const config = exports = {};

  config.mysql = {
    // 单数据库信息配置
    client: {
      // host
      host: 'godokyang.top',
      // 端口号
      port: '3306',
      // 用户名
      user: 'root',
      // 密码
      password: '!qaz2wsx',
      // 数据库名
      database: 'ChenAnDB',
    },
    // 是否加载到 app 上，默认开启
    app: true,
    // 是否加载到 agent 上，默认关闭
    agent: false,
  };

  return { ...config };
};
