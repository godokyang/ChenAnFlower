'use strict';

/**
 * @param {Egg.Application} app - egg application
 */
module.exports = app => {
  const { router, controller } = app;
  router.get('/', controller.home.index);
  router.get('/user/loginOrRegister', controller.user.loginOrRegister);
  router.get('/user/userInfo', controller.user.getUserInfo);
  router.get('/goods', controller.goods.getGoods);
  router.get('/goods/indsertGoodsInfo', controller.goods.insertGoodsInfo);
  router.get('/shoppingCart', controller.shoppingCart.getShoppingCartInfo);
  // router.get('/insertAddress', controller.address.createAddress);
  router.get('/insertAddress', controller.address.updateAddress);
  router.get('/order', controller.order.confrimOrder);
};
