'use strict';

const Controller = require('egg').Controller;

class OrderCartController extends Controller {
  async confrimOrder() {
    const { ctx } = this;
    const result = await ctx.service.order.confirmOrder([
      { sku: 1000001, quantity: 7 },
      { sku: 1000002, quantity: 1 },
      { sku: 1000003, quantity: 1 },
      { sku: 1000004, quantity: 3 },
      { sku: 1000006, quantity: 7 },
    ]);
    ctx.body = result;
  }
}

module.exports = OrderCartController;
