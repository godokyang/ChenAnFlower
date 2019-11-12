'use strict';

const Controller = require('egg').Controller;

class ShoppingCartController extends Controller {
  async getShoppingCartInfo() {
    const { ctx } = this;
    const result = await ctx.service.shoppingCart.getShoppingCartInfo([
      { sku: 1000001, quantity: 7 },
      { sku: 1000002, quantity: 1 },
      { sku: 1000003, quantity: 1 },
      { sku: 10000904, quantity: 3 },
      { sku: 10000309, quantity: 7 },
    ]);
    ctx.body = result;
  }
}

module.exports = ShoppingCartController;
