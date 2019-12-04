'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');
const uuid = require('uuid');
const _lodash = require('lodash')

const verifyOrder = params => {
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
    if (!arr || !arr[0]) {
      return Object.assign({}, Code.ERROR, {
        message: 'ConfirmOrder Paramters Not Right',
        error_code: 600
      });
    }
    const allow = arr.every(item => {
      return item.sku && item.quantity;
    });

    if (!allow) {
      // sku or quantity is not define in paramters
      return Object.assign({}, Code.ERROR, {
        message: 'ConfirmOrder Paramters Not Right',
        error_code: 600
      });
    }

    const userRes = ctx.header.user_info;

    if (!userRes.status) {
      return Object.assign({}, Code.ACCESSINVALID);
    }

    const addressRes = await ctx.app.mysql.select('ChenAnDB_address', {
      customer_id: userRes.customer_id
    });

    const result = await ctx.service.common.getGoodsBySkus(arr);
    if (result.status) {
      if (_lodash.get(addressRes, '[0].address_id', null)) {
        result.data.address = addressRes[0];
      } else {
        result.data.address = {}
      }
      return Object.assign({}, Code.SUCCESS, {
        data: { order_info: result.data }
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
    const address = _lodash.get(obj, 'address', null)
    let addressRes = null
    if (address) {
      const noDefineList = [];
      for (const key in address) {
        if (address.hasOwnProperty(key)) {
          const element = address[key];
          if (!element) {
            noDefineList.push(key);
          }
        }
      }

      if (noDefineList.length > 0) {
        return Object.assign({}, Code.ERROR, {
          message: `Following Data Has Not Define: ${noDefineList.toString()}`,
          error_code: 600
        });
      }

      if (address.address_id) {
        addressRes = await ctx.app.mysql.update('ChenAnDB_address', {
          ADD_ID: address.ADD_ID, 
          detail: address.detail,
          contact: address.contact, 
          receiver: address.receiver
        }, {
          where: { address_id: address.address_id }
        });
      } else {
        addressRes = await ctx.app.mysql.insert('ChenAnDB_address', Object.assign(address, {customer_id: userRes.customer_id, address_id: uuid.v1()}));
      }
    }
    if (addressRes.affectedRows !== 1) {
      return Object.assign({message: 'address wrong'}, Code.ERROR);
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
        customer_name: userRes.user_name,
        create_time: new Date().getTime()
      }); // 第一步操作
      for (const item of obj.items) {
        await conn.insert('ChenAnDB_order_goods', {
          order_id,
          sku: item.sku,
          goods_name: item.goods_name,
          goods_count: item.quantity,
          shop_id: item.owner_shop_id,
          goods_price: item.sale_price,
          images: item.images,
          video: item.video
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
    const { last_id = 0, page_size = 10 } = ctx.request.query;
    if (!userRes.status) {
      return Object.assign({}, Code.ACCESSINVALID);
    }
    
    const listQueryData = await ctx.app.mysql.beginTransactionScope(async conn => {
      let list = userRes.identify === 100 ? 
        await this.app.mysql.query(`SELECT * FROM ChenAnDB_order_info order by order_number desc ${last_id ? `WHERE order_number < ${last_id}` : ''} LIMIT ${page_size};`):
        await this.app.mysql.query(`SELECT * FROM ChenAnDB_order_info order by order_number desc WHERE customer_id = ${userRes.customer_id} ${last_id ? `AND order_number < ${last_id}` : ''};`) 
      
      
      
      let payment_mapping = await conn.select('ChenAnDB_payment_way_mapping', {
        limit: 10
      });

      let order_status_mapping = await conn.select('ChenAnDB_order_status_mapping', {
        limit: 10
      });
      
      return Object.assign({order_status_mapping},{user_info: userRes},{payment_mapping},{list});
    }, ctx); 
    return Object.assign({}, Code.SUCCESS, {
      data: { order_list: listQueryData }
    });
  }

  async getOrderGoods() {
    const { ctx } = this;
    const { order_id } = ctx.params;
    if (!order_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'wrong paramters',
        error_code: 600
      });
    }

    const result = await ctx.app.mysql.select('ChenAnDB_order_goods', {
      where: { order_id }
    });

    return Object.assign({}, Code.SUCCESS, {
      data: {
        list: result
      }
    });
  }

  async updateOrderInfo() {
    const { ctx } = this;
    const { order_id } = ctx.params;
    const userRes = ctx.request.header.user_info;
    const { order_status } = ctx.request.body;
    if (!order_status) {
      return Object.assign({}, Code.ERROR, {
        message: 'Address Paramters Has Error',
        error_code: 600
      });
    }

    if (!userRes.status || userRes.identify !== 100) {
      return Object.assign({}, Code.ACCESSINVALID);
    }

    if (!order_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Order_id Selected',
        error_code: 600
      });
    }
    const insertFlag = await this.app.mysql.select('ChenAnDB_order_status_mapping',{
      order_status
    })

    if (insertFlag.length === 0) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Order Status Mapping',
        error_code: 600
      });
    }

    const result = await this.app.mysql.update('ChenAnDB_order_info', {
      order_status
    }, {
      where: { order_id }
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }
    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603
    });

  }
}

module.exports = OrderService;
