'use strict';

module.exports = options => {
  return async function checkReponse(ctx, next) {
    await next();
    if (ctx.url.indexOf('/web/') !== -1 && ctx.response.status === 404) {
      ctx.redirect('/web/home');
    }
  };
}
;
