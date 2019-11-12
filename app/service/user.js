'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');

class UserService extends Service {
  async loginOrRegister(user_name, password) {
    // 创建和登录一体
    const userCountQuery = await this.app.mysql.query(`select count(*) from ChenAnDB_user where user_name = '${user_name}'`);

    const userCount = userCountQuery[0]['count(*)'];
    if (userCount === 0) {
      await this.app.mysql.insert('ChenAnDB_user', {
        user_name,
        password,
      });
    }
    const userQuery = await this.app.mysql.get('ChenAnDB_user', { user_name });

    // sign 中的payload需要是一个纯函数对象
    const user = Object.assign({}, userQuery);
    if (user.password !== password) {
      return Object.assign({}, Code.ERROR, {
        message: 'AccessIsExsitsWidthWrongPassword',
        error_code: 602,
        data: null,
      });
    }
    delete user.password;
    const token = await this.ctx.app.generateToken(user);
    return Object.assign({}, Code.SUCCESS, {
      data: { access_token: token },
    });
  }

  async getUserInfo(at) {
    const info = await this.ctx.app.verifyToken(at);

    return Object.assign({}, Code.SUCCESS, {
      data: { user_info: info },
    });
  }
}

module.exports = UserService;
