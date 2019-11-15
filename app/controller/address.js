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
    ctx.body = result;
  }

  async deleteAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.deleteAddress();
    ctx.body = result;
  }
}

module.exports = AddressController;
