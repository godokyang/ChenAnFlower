'use strict';

const Controller = require('egg').Controller;

class UserController extends Controller {
  async loginOrRegister() {
    const { ctx } = this;
    const result = await ctx.service.user.loginOrRegister('test', '222222');
    ctx.body = result;
  }

  async getUserInfo() {
    const { ctx } = this;
    const result = await ctx.service.user.getUserInfo(ctx.header.Authorization);
    ctx.body = result;
  }
}

module.exports = UserController;
