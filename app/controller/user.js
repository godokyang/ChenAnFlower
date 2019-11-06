'use strict';

const Controller = require('egg').Controller;

class UserController extends Controller {
  async create() {
    const { ctx } = this;
    const result = await ctx.service.user.create('test', 222222);
    ctx.body = result;
  }
}

module.exports = UserController;
