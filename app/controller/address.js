'use strict';

const Controller = require('egg').Controller;

class AddressController extends Controller {
  async createAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.createAddress({
      ADD_ID: '1558',
      detail: '测试',
      contact: 18623106152,
      receiver: '杨科',
      customer_id: 10000000001,
    });
    ctx.body = result;
  }

  async updateAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.updateAddress({
      detail: '测试不打',
      contact: 1877777772,
      receiver: '杨科1',
      address_id: '088eb780-045a-11ea-a4ce-5742e1169183',
    });
    ctx.body = result;
  }

  async deleteAddress() {
    const { ctx } = this;
    const result = await ctx.service.address.deleteAddress('088eb780-045a-11ea-a4ce-5742e1169183');
    ctx.body = result;
  }
}

module.exports = AddressController;
