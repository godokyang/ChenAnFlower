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
    if (!ADD_ID || !detail || !contact || !receiver) {
      return Object.assign({}, Code.ERROR, {
        message: 'Address Paramters Has Error',
        error_code: 600
      });
    }
    const insertData = {
      ADD_ID,
      detail,
      contact,
      receiver,
      customer_id,
      address_id: uuid.v1()
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
        error_code: 600
      });
    }
    const countRes = await this.app.mysql.select('ChenAnDB_address', {
      where: { customer_id }
    });

    if (countRes && countRes.length > 0) {
      return Object.assign({}, Code.ERROR, {
        message: 'Address Count Has Up To Limit',
        error_code: 605
      });
    }
    const result = await this.app.mysql.insert('ChenAnDB_address', insertData);
    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }
    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603
    });
  }

  async updateAddress() {
    const { ctx } = this;
    const { address_id } = ctx.params;
    const { customer_id } = ctx.request.header;
    const { ADD_ID, detail, contact, receiver } = ctx.request.body;
    if (!ADD_ID || !detail || !contact || !receiver || !address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'Address Paramters Has Error',
        error_code: 600
      });
    }
    if (!address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Address_id Selected',
        error_code: 600
      });
    }

    const countRes = await this.app.mysql.select('ChenAnDB_address', {
      where: { address_id, customer_id }
    });

    if (countRes.length === 0) {
      return Object.assign({}, Code.ERROR, {
        message: 'No Address_id In Database',
        error_code: 604
      });
    }

    const result = await this.app.mysql.update('ChenAnDB_address', {
      ADD_ID, detail, contact, receiver
    }, {
      where: { address_id }
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }
    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603
    });
  }

  async deleteAddress() {
    const { ctx, app } = this;
    const { address_id } = ctx.params;
    const { customer_id } = ctx.request.header.user_info;
    if (!address_id) {
      return Object.assign({}, Code.ERROR, {
        message: 'address_id Is Not Define',
        error_code: 600
      });
    }

    const result = await app.mysql.delete('ChenAnDB_address', {
      address_id,
      customer_id
    });

    if (result.affectedRows === 1) {
      return Object.assign({}, Code.SUCCESS);
    }

    return Object.assign({}, Code.ERROR, {
      message: 'Insert Failed',
      error_code: 603,
      error: result
    });
  }

  async getOrgin() {
    const { ctx, app } = this;
    const { id } = ctx.params;
    if (!id || id === 'undefined') {
      return Object.assign({}, Code.ERROR, {
        message: 'id Is Not Define',
        error_code: 600
      });
    }
    // 0: province 1: 根据ID拿二级目录 2:根据city拿全部
    const { type } = ctx.request.query
    if (!type || Number(type) === 0) {
      const orginQueryData = await app.mysql.query('SELECT * FROM pub_address_inf WHERE ADD_CITYCODE = 000000')
      return Object.assign({}, Code.SUCCESS, {
        data: { orgin: orginQueryData }
      });
    }
    if (Number(type) === 1) {
      const orginQueryData = await app.mysql.beginTransactionScope(async conn => {
        let curOrgin = await conn.get('pub_address_inf', {
          ADD_ID: id
        });
        let curSub = await conn.query(`SELECT * FROM pub_address_inf WHERE ADD_CITYCODE = ${curOrgin['ADD_CODE']}`)
        return curSub;
      }, ctx); 
      return Object.assign({}, Code.SUCCESS, {
        data: { orgin: orginQueryData }
      });
    }

    if (Number(type) === 2) {
      const orginQueryData = await app.mysql.beginTransactionScope(async conn => {
        // don't commit or rollback by yourself
        let curCity = await conn.get('pub_address_inf', {
          ADD_ID: id
        });
        let curCounty = await conn.get('pub_address_inf', {
          ADD_CODE: curCity['ADD_CITYCODE']
        })
        let curProvince = await conn.get('pub_address_inf', {
          ADD_CODE: curCounty['ADD_CITYCODE']
        })
        
        return {
          province: curProvince || {},
          county: curCounty || {},
          city: curCity || {}
        };
      }, ctx);
      return Object.assign({}, Code.SUCCESS, {
        data: { orgin: orginQueryData }
      });
    }
    
    return Object.assign({}, Code.ERROR, {
      message: 'paramters wrong',
      error_code: 600
    });
  }

  async getAddress() {
    const { ctx, app } = this;
    const { address_id } = ctx.params;
    if (!address_id || address_id === 'undefined') {
      return Object.assign({}, Code.ERROR, {
        message: 'id Is Not Define',
        error_code: 600
      });
    }

    try {
      const addressRes = await app.mysql.get('ChenAnDB_address', {address_id: address_id})
      const orginQueryData = await app.mysql.beginTransactionScope(async conn => {
        // don't commit or rollback by yourself
        let curCity = await conn.get('pub_address_inf', {
          ADD_ID: addressRes.ADD_ID
        });
        let curCounty = await conn.get('pub_address_inf', {
          ADD_CODE: curCity['ADD_CITYCODE']
        })
        let curProvince = await conn.get('pub_address_inf', {
          ADD_CODE: curCounty['ADD_CITYCODE']
        })
        
        return {
          province: curProvince || {},
          county: curCounty || {},
          city: curCity || {}
        };
      }, ctx);
      addressRes.orgin = orginQueryData
      return Object.assign({}, Code.SUCCESS, {
        data: { address: addressRes }
      });
    } catch (error) {
      return Object.assign({}, Code.ERROR, {
        message: 'Get Data Failed',
        error_code: 603
      });
    }
  }
}

module.exports = AddressService;
