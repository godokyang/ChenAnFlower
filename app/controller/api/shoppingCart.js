'use strict';

const Controller = require('egg').Controller;

class ShoppingCartController extends Controller {
  async getShoppingCartInfo() {
    const { ctx } = this;
    const result = await ctx.service.shoppingCart.getShoppingCartInfo();
    ctx.body = result;
  }
}

module.exports = ShoppingCartController;
