'use strict';

module.exports = options => {
  return async function catchThrowError(ctx, next) {
    try {
      await next();
    } catch (error) {
      ctx.logger.error(error);
      ctx.response.status = 500;
      ctx.body = {
        data: error,
      };
    }
  };
}
;
