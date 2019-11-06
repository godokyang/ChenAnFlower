'use strict';

const Service = require('egg').Service;

class UserService extends Service {
  async create(user_name, password) {
    const userCount = await this.app.mysql.query(`select count(*) from ChenAnDB_user where user_name = '${user_name}'`);

    if (!userCount) {
      return {
        status: false,
        message: 'AddAccessFailed',
      };
    }

    if (userCount[0]['count(*)'] === 0) {
      await this.app.mysql.insert('ChenAnDB_user', {
        user_name,
        password,
      });
    }
    const user = await this.app.mysql.get('ChenAnDB_user', { user_name });
    if (!user) {
      return {
        status: false,
        message: 'AddAccessFailed',
      };
    }
    const RowDataPacket = user.RowDataPacket;
    if (RowDataPacket && RowDataPacket.password !== password) {
      return {
        status: false,
        message: 'AccessIsExsitsWidthWrongPassword',
      };
    }

    const token = await this.ctx.app.generateToken(RowDataPacket);
    return {
      status: true,
      message: userCount ? 'AccessIsExsits' : 'Created',
      access_token: token,
    };
    // const createSuccess = result.affectedRows === 1;
    // return createSuccess;
  }

  async login(username, password) {

  }

  async remove(username, password) {

  }
}

module.exports = UserService;
