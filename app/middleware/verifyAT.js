'use strict';
const { Code } = require('../utils/util');

module.exports = options => {
  return async function verifyAT(ctx, next) {
    const atCheckFlag = options.noAccessAPIs.some(item => {
      return item === ctx.request.url;
    });
    const res = await ctx.app.verifyToken(ctx.request.header.authorization);
    if (res.status || atCheckFlag) {
      if (!atCheckFlag) {
        ctx.request.header.user_info = res;
      }
      await next();
    } else {
      ctx.response.status = Code.ACCESSINVALID.status;
      ctx.body = Code.ACCESSINVALID.message;
    }
  };
}
;
