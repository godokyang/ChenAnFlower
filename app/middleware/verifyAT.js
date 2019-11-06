'use strict';

module.exports = options => {
  return async function verifyAT(ctx, next) {
    const atCheckFlag = options.noAccessAPIs.some(item => {
      return item === ctx.request.url;
    });
    const res = await ctx.app.verifyToken(ctx.header.Authorization);
    if (res.status || atCheckFlag) {
      await next();
    } else {
      ctx.status = 401;
      ctx.message = 'AccessToken Is Invalid';
    }
  };
}
;
