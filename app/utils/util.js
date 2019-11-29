'use strict';

module.exports = {
  Code: {
    SUCCESS: {
      status: 200,
      error_code: 0,
      message: 'Success'
    },
    ACCESSINVALID: {
      status: 401,
      error_code: 0,
      message: 'AccessToken Is Invalid'
    },
    ERROR: {
      status: 400,
      error_code: 0,
      message: 'Invalid Requirement'
    }
  },
  ErrorCodeMap: {
    0: '不需要捕获的异常',
    600: '参数失效',
    601: '购物车中有失效产品',
    602: '错误的用户名或密码',
    603: '数据库操作失败',
    604: '数据库中没有数据',
    605: '数量达到业务上线，拒绝操作',
    606: '数据已存在，拒绝操作'
  }
}
;
