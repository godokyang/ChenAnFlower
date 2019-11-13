'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');
const uuid = require('uuid');

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

  async submitOrder(obj) {
    const { ctx } = this;
    const userRes = await ctx.app.verifyToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmeSI6MCwidXNlcl9uYW1lIjoidGVzdCIsIm5pY2tfbmFtZSI6bnVsbCwicGhvbmVfbnVtYmVyIjpudWxsLCJlbWFpbCI6bnVsbCwiaGVhZF9pbWFnZSI6bnVsbCwiY3JlYXRlX3RpbWUiOjAsInVuaW9uX2lkIjpudWxsLCJjdXN0b21lcl9pZCI6MTAwMDAwMDAwMDIsInN0YXR1cyI6MTAsImlhdCI6MTU3MzU1MTY2NSwiZXhwIjoxNTczODEwODY1fQ.valDyNdfvhe7Eq1HBcalFqAgiFcHkTjQk2geDYbRTuY');

    if (!userRes.status) {
      return Object.assign({}, Code.ACCESSINVALID);
    }

    const order_id = uuid.v1();

    const conn = await ctx.app.mysql.beginTransaction(); // 初始化事务
    const total = obj.agent_id ? obj.sale_total : obj.agent_total;
    try {
      await conn.insert('ChenAnDB_order_info', {
        order_id,
        customer_id: userRes.customer_id,
        address_id: obj.address.address_id,
        goods_total: total,
        payment_total: total,
        payment_way: 900,
        order_status: 10100,
        create_time: new Date().getTime(),
      }); // 第一步操作
      for (const item of obj.items) {
        await conn.insert('ChenAnDB_order_goods', {
          order_id,
          sku: item.sku,
          goods_name: item.goods_name,
          goods_count: item.quantity,
          shop_id: item.owner_shop_id,
          goods_price: item.sale_price,
        });
      }
      // 第二步操作
      await conn.commit(); // 提交事务
      return Object.assign({}, Code.SUCCESS);
    } catch (err) {
      // error, rollback
      await conn.rollback(); // 一定记得捕获异常后回滚事务！！
      throw err;
    }
  }

  async getOrderList() {
    const { ctx } = this;
    const userRes = await ctx.app.verifyToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmeSI6MCwidXNlcl9uYW1lIjoidGVzdCIsIm5pY2tfbmFtZSI6bnVsbCwicGhvbmVfbnVtYmVyIjpudWxsLCJlbWFpbCI6bnVsbCwiaGVhZF9pbWFnZSI6bnVsbCwiY3JlYXRlX3RpbWUiOjAsInVuaW9uX2lkIjpudWxsLCJjdXN0b21lcl9pZCI6MTAwMDAwMDAwMDIsInN0YXR1cyI6MTAsImlhdCI6MTU3MzU1MTY2NSwiZXhwIjoxNTczODEwODY1fQ.valDyNdfvhe7Eq1HBcalFqAgiFcHkTjQk2geDYbRTuY');

    if (!userRes.status) {
      return Object.assign({}, Code.ACCESSINVALID);
    }

    const result = await ctx.app.mysql.select('ChenAnDB_order_info', {
      customer_id: userRes.customer_id,
    });

    return Object.assign({}, Code.SUCCESS, {
      data: {
        list: result,
      },
    });
  }

  async getOrderGoods(order_id) {
    const { ctx } = this;

    if (!order_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'wrong paramters',
        error_code: 600,
      });
    }

    const result = await ctx.app.mysql.select('ChenAnDB_order_goods', {
      order_id,
    });

    return Object.assign({}, Code.SUCCESS, {
      data: {
        list: result,
      },
    });
  }
}

module.exports = OrderService;
