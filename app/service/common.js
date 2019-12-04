'use strict';

const Service = require('egg').Service;

class CommonService extends Service {
  async getGoodsBySkus(arr) {
    /**
     * obj: [
     * {sku: xxx, quantity: xxx}
     * ]
     */
    if (!arr || !arr[0]) {
      return { status: false, data: null };
    }
    const allow = arr.every(item => {
      return item.sku && item.quantity;
    });

    if (!allow) {
      return { status: false, data: null };
    }

    const responseArr = {
      owner_total: 0,
      agent_total: 0,
      sale_total: 0,
      items: []
    };

    const failedSkus = [];
    for (const iterator of arr) {
      const result = await this.app.mysql.select('ChenAnDB_goods', {
        where: {
          sku: iterator.sku
        },
        columns: [ 'goods_name', 'pro_desc', 'images', 'sale_price', 'agent_price', 'sku', 'owner_price', 'top_level', 'show_level', 'owner_shop_id' ]
      });
      
      if (result.length === 0) {
        failedSkus.push(iterator.sku);
        continue;
      }
      const pushData = result[0];
      const Owner = await this.app.mysql.select('ChenAnDB_owner_shop', {
        where: {
          shop_id: pushData.owner_shop_id
        }
      })
      if (Owner.length === 0) {
        failedSkus.push(iterator.sku);
        continue;
      }
      pushData.owner = Owner[0]
      pushData.quantity = iterator.quantity;
      responseArr.owner_total += pushData.owner_price * pushData.quantity;
      responseArr.sale_total += pushData.sale_price * pushData.quantity;
      responseArr.agent_total += pushData.agent_price * pushData.quantity;
      responseArr.items.push(pushData);
    }


    if (failedSkus.length !== 0) {
      return { status: false, errorData: failedSkus };
    }

    return { status: true, data: responseArr };
  }
}

module.exports = CommonService;
