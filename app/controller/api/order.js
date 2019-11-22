'use strict';

const Controller = require('egg').Controller;

class OrderCartController extends Controller {
  async confrimOrder() {
    const { ctx } = this;
    const result = await ctx.service.order.confirmOrder();
    ctx.body = result;
  }

  async submitOrder() {
    const { ctx } = this;
    const result = await ctx.service.order.submitOrder();
    ctx.body = result;
  }

  async getOrderList() {
    const { ctx } = this;
    const result = await ctx.service.order.getOrderList();
    ctx.body = result;
  }

  async getOrderGoods() {
    const { ctx } = this;
    const result = await ctx.service.order.getOrderGoods();
    ctx.body = result;
  }
}

module.exports = OrderCartController;
