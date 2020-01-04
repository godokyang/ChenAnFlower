'use strict';

const Service = require('egg').Service;
const { Code } = require('../utils/util');

class GoodsService extends Service {
  async getGoods() {
    const { ctx } = this;
    const { last_id = 0, page_size = 10 } = ctx.request.query;
    const userRes = ctx.request.header.user_info;
    let query = `SELECT * FROM ChenAnDB_goods ${last_id ? `WHERE sku < ${last_id}` : ''} order by sku desc LIMIT ${page_size};`
    if (!userRes || userRes.identify === 0) {
      query = `SELECT * FROM ChenAnDB_goods WHERE show_level = 2 ${last_id ? `AND sku < ${last_id}` : ''} order by sku desc LIMIT ${page_size};`
    }
    const goodsQueryData = await this.app.mysql.query(query);
    return Object.assign({}, Code.SUCCESS, {
      data: { goods: goodsQueryData }
    });
  }

  async insertGoodsInfo() {
    /**
     UPDATE ChenAnDB_goods SET
      pro_desc = ${pro_desc},
      owner_price=${owner_price},
      sale_price=${sale_price},
      agent_price=${agent_price},
      top_level=${top_level},
      show_level=${show_level}
      WHERE sku = ${sku}
     */
    const { ctx } = this;
    const { pro_desc, owner_price, sale_price, agent_price, top_level, show_level, sku } = ctx.request.body;
    if (!sku) {
      return Object.assign({}, Code.ERROR, {
        message: 'Sku Is Not Define',
        error_code: 600
      });
    }
    const insertObj = {
      pro_desc, owner_price, sale_price, agent_price, top_level, show_level, sku
    };
    const result = await this.app.mysql.update('ChenAnDB_goods', insertObj, {
      where: { sku }
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

module.exports = GoodsService;
