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
    const result = await ctx.service.goods.insertGoodsInfo({
      pro_desc: '测试',
      owner_price: 100,
      sale_price: 100,
      agent_price: 100,
      top_level: 0,
      show_level: 0,
      sku: 1000001,
    });
    ctx.body = result;
  }
}

module.exports = GoodsController;
