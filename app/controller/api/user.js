'use strict';

const Controller = require('egg').Controller;

class UserController extends Controller {
  async loginOrRegister() {
    const { ctx } = this;
    const result = await ctx.service.user.loginOrRegister();
    ctx.response = Object.assign(ctx.response, result)
    ctx.body = result;
  }

  async getUserInfo() {
    const { ctx } = this;
    const result = await ctx.service.user.getUserInfo();
    ctx.response = Object.assign(ctx.response, result)
    ctx.body = result;
  }
}

module.exports = UserController;
