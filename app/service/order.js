'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');
const uuid = require('uuid');

/**
 *
 *
{
	"owner_total": 700,
	"agent_total": 700,
	"sale_total": 700,
	"items": [{
		"goods_name": "11月10日云南宏杰鲜花种植基地保鲜红玫，报价更新如下:B级，100扎，21.5元C.级，130扎，19元D级，80扎，16元全部灰霉处理，所有等级枝枝到底，全部基地新鲜采摘，绝无冷藏货，有售后保障，需要的麻烦早点下单，大量有货，每天20点开始配送",
		"pro_desc": "测试",
		"images": "https://xcimg.szwego.com/20191110/a1573356924776_0714.jpg?imageView2/2/format/jpg/q/100",
		"sale_price": 100,
		"agent_price": 100,
		"sku": 1000001,
		"owner_price": 100,
		"top_level": 0,
		"show_level": 0,
		"owner_shop_id": "A201902190956237250142523",
		"quantity": 7
	}],
	"address": {
		"detail": "测试不打",
		"contact": "1877777772",
		"receiver": "杨科1",
		"customer_id": 10000000001,
		"address_id": "088eb780-045a-11ea-a4ce-5742e1169183",
		"ADD_ID": 1558
	}
}
 */
function verifyOrder(params) {
  // TODO order check
  console.log(params);
  return false;
}

class OrderService extends Service {
  async confirmOrder() {
    /**
     * obj: [
     * {sku: xxx, quantity: xxx}
     * ]
     */
    const { ctx } = this;
    const arr = ctx.request.body;
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

    const userRes = ctx.header.user_info;

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

  async submitOrder() {
    const { ctx } = this;
    const obj = ctx.request.body;
    const userRes = ctx.request.header.user_info;
    if (!userRes.status) {
      return Object.assign({}, Code.ACCESSINVALID);
    }

    const order_id = uuid.v1();

    const conn = await ctx.app.mysql.beginTransaction(); // 初始化事务
    const total = obj.agent_id ? obj.sale_total : obj.agent_total;
    if (verifyOrder()) {
      return Object.assign({}, Code.ERROR);
    }
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
    const userRes = ctx.request.header.user_info;

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

  async getOrderGoods() {
    const { ctx } = this;
    const { order_id } = ctx.params;
    if (!order_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'wrong paramters',
        error_code: 600,
      });
    }

    const result = await ctx.app.mysql.select('ChenAnDB_order_goods', {
      where: { order_id },
    });

    return Object.assign({}, Code.SUCCESS, {
      data: {
        list: result,
      },
    });
  }
}

module.exports = OrderService;
