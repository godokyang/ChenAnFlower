'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');

class ShoppingCartService extends Service {
  async getShoppingCartInfo() {
    /**
     * obj: [
     * {sku: xxx, quantity: xxx}
     * ]
     */
    const { ctx } = this;
    const arr = ctx.request.body;
    const result = await ctx.service.common.getGoodsBySkus(arr);

    if (result.status) {
      return Object.assign({}, Code.SUCCESS, {
        data: { pro_infos: result.data }
      });
    }

    if (result.errorData) {
      return Object.assign({}, Code.ERROR, {
        message: `Not All Sku Effective: ${result.errorData}`,
        error_code: 601
      });
    }

    return Object.assign({}, Code.ERROR, {
      message: 'Sku Or Quantity Is Not Define In The Paramters',
      error_code: 600
    });
  }
}

module.exports = ShoppingCartService;
