'use strict';

const Controller = require('egg').Controller;

class AddressController extends Controller {
  async createAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.createAddress();
    ctx.body = result;
  }

  async updateAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.updateAddress();
    ctx.response = Object.assign(ctx.response, result)
    ctx.body = result;
  }

  async deleteAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.deleteAddress();
    ctx.response = Object.assign(ctx.response, result)
    ctx.body = result;
  }

  async getOrgin() {
    const { ctx } = this;
    const result = await ctx.service.address.getOrgin();
    ctx.response = Object.assign(ctx.response, result)
    ctx.body = result;
  }
}

module.exports = AddressController;
