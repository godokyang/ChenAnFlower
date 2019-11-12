'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');

class OrderService extends Service {
  async confirmOrder(arr) {
    /**
     * obj: [
     * {sku: xxx, quantity: xxx}
     * ]
     */
    const { ctx } = this;
    const allow = arr.every(item => {
      return item.sku && item.quantity;
    });

    if (!allow) {
      // sku or quantity is not define in paramters
      return Object.assign({}, Code.ERROR, {
        message: 'ShoppingCart Paramters Not Right',
        error_code: 600,
      });
    }

    const userRes = await ctx.app.verifyToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmeSI6MCwidXNlcl9uYW1lIjoidGVzdCIsIm5pY2tfbmFtZSI6bnVsbCwicGhvbmVfbnVtYmVyIjpudWxsLCJlbWFpbCI6bnVsbCwiaGVhZF9pbWFnZSI6bnVsbCwiY3JlYXRlX3RpbWUiOjAsInVuaW9uX2lkIjpudWxsLCJjdXN0b21lcl9pZCI6MTAwMDAwMDAwMDIsInN0YXR1cyI6MTAsImlhdCI6MTU3MzU1MTY2NSwiZXhwIjoxNTczODEwODY1fQ.valDyNdfvhe7Eq1HBcalFqAgiFcHkTjQk2geDYbRTuY');

    if (!userRes.status) {
      return Object.assign({}, Code.ACCESSINVALID);
    }

    const addressRes = await ctx.app.mysql.select('ChenAnDB_address', {
      customer_id: userRes.customer_id,
    });

    console.log('-------------1--------------', addressRes);

    const result = await ctx.service.common.getGoodsBySkus(arr);
    if (result.status) {
      if (addressRes[0].address_id) {
        result.data.address = addressRes[0];
      }
      return Object.assign({}, Code.SUCCESS, {
        data: { order_info: result.data },
      });
    }

    if (result.errorData) {
      return Object.assign({}, Code.ERROR, {
        message: `Not All Sku Effective: ${result.errorData}`,
        error_code: 601,
      });
    }

    return Object.assign({}, Code.ERROR, {
      message: 'Sku Or Quantity Is Not Define In The Paramters',
      error_code: 600,
    });
  }
}

module.exports = OrderService;
