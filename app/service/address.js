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
  async createAddress(obj) {
    const { ctx } = this;
    if (obj.address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'Address Has Already Exists',
        error_code: 606,
      });
    }

    const defaultData = {
      ADD_ID: null,
      detail: null,
      contact: null,
      receiver: null,
      customer_id: null,
      address_id: uuid.v1(),
    };
    const insertData = Object.assign(defaultData, obj);
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
      where: { customer_id: obj.customer_id },
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

  async updateAddress(obj) {
    if (!obj.address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Address_id Selected',
        error_code: 600,
      });
    }

    const countRes = await this.app.mysql.select('ChenAnDB_address', {
      where: { address_id: obj.address_id },
    });

    if (countRes.length === 0) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Address_id In Database',
        error_code: 604,
      });
    }

    const result = await this.app.mysql.update('ChenAnDB_address', obj, {
      where: { address_id: obj.address_id },
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }
    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603,
    });
  }

  async deleteAddress(address_id) {
    if (!address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'address_id Is Not Define',
        error_code: 600,
      });
    }
    const result = this.app.mysql.delete('ChenAnDB_address', {
      address_id,
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }

    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603,
    });
  }
}

module.exports = AddressService;
