'use strict';

const Controller = require('egg').Controller;

class GoodsController extends Controller {
  async getGoods() {
    const { ctx } = this;
    const result = await ctx.service.goods.getGoods();
    ctx.body = result;
  }

  async insertGoodsInfo() {
    const { ctx } = this;
    const result = await ctx.service.goods.insertGoodsInfo();
    ctx.body = result;
  }
}

module.exports = GoodsController;
