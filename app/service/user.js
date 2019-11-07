'use strict';

const Service = require('egg').Service;

class UserService extends Service {
  async loginOrRegister(user_name, password) {
    // 创建和登录一体
    const userCountQuery = await this.app.mysql.query(`select count(*) from ChenAnDB_user where user_name = '${user_name}'`);

    if (!userCountQuery) {
      return {
        status: false,
        message: 'AddAccessFailed',
      };
    }
    const userCount = userCountQuery[0]['count(*)'];
    if (userCount === 0) {
      await this.app.mysql.insert('ChenAnDB_user', {
        user_name,
        password,
      });
    }
    const userQuery = await this.app.mysql.get('ChenAnDB_user', { user_name });
    if (!userQuery) {
      return {
        status: false,
        message: 'AddAccessFailed',
      };
    }
    // sign 中的payload需要是一个纯函数对象
    const user = Object.assign({}, userQuery);
    if (user.password !== password) {
      return {
        status: false,
        message: 'AccessIsExsitsWidthWrongPassword',
      };
    }
    delete user.password;
    const token = await this.ctx.app.generateToken(user);
    return {
      status: true,
      message: userCount ? 'AccessIsExsits' : 'Created',
      access_token: token,
    };
  }

  async getUserInfo(at) {
    const info = await this.ctx.app.verifyToken(at);

    return {
      status: true,
      user_info: info,
    };
  }
}

module.exports = UserService;
