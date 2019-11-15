'use strict';

const Service = require('egg').Service;
const uuid = require('uuid');
const { Code } = require('../utils/util');

/**
 * address paramters structure
 * obj: {
 *  province_id,
 *  province_name,
 *  city_id,
 *  city_name,
 *  county_id,
 *  county_name,
 *  detail,
 *  contact,
 *  receiver,
 *  customer_id,
 * address_id
 * }
 */
class AddressService extends Service {
  async createAddress() {
    const { ctx } = this;
    const { ADD_ID, detail, contact, receiver } = ctx.request.body;
    const { customer_id } = ctx.request.header.user_info;
    const insertData = {
      ADD_ID,
      detail,
      contact,
      receiver,
      customer_id,
      address_id: uuid.v1(),
    };
    // const insertData = Object.assign(defaultData, obj);
    const noDefineList = [];
    for (const key in insertData) {
      if (insertData.hasOwnProperty(key)) {
        const element = insertData[key];
        if (!element) {
          noDefineList.push(key);
        }
      }
    }

    if (noDefineList.length > 0) {
      ctx.app.createResponse(Code.ERROR.status, 600, `Following Data Has Not Define: ${noDefineList.toString()}`);
      return Object.assign({}, Code.ERROR, {
        message: `Following Data Has Not Define: ${noDefineList.toString()}`,
        error_code: 600,
      });
    }
    const countRes = await this.app.mysql.select('ChenAnDB_address', {
      where: { customer_id },
    });

    if (countRes && countRes.length > 0) {
      return Object.assign({}, Code.ERROR, {
        message: 'Address Count Has Up To Limit',
        error_code: 605,
      });
    }
    const result = await this.app.mysql.insert('ChenAnDB_address', insertData);
    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }
    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603,
    });
  }

  async updateAddress() {
    const { ctx } = this;
    const { address_id } = ctx.params;
    const { customer_id } = ctx.request.header;
    const { ADD_ID, detail, contact, receiver } = ctx.request.body;

    if (!address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Address_id Selected',
        error_code: 600,
      });
    }

    const countRes = await this.app.mysql.select('ChenAnDB_address', {
      where: { address_id, customer_id },
    });

    if (countRes.length === 0) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Address_id In Database',
        error_code: 604,
      });
    }

    const result = await this.app.mysql.update('ChenAnDB_address', {
      ADD_ID, detail, contact, receiver,
    }, {
      where: { address_id },
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }
    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603,
    });
  }

  async deleteAddress() {
    const { ctx, app } = this;
    const { address_id } = ctx.params;
    const { customer_id } = ctx.request.header.user_info;
    if (!address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'address_id Is Not Define',
        error_code: 600,
      });
    }

    const result = await app.mysql.delete('ChenAnDB_address', {
      address_id,
      customer_id,
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }

    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603,
      error: result,
    });
  }
}

module.exports = AddressService;
