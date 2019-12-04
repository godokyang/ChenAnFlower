'use strict';

/**
 * @param {Egg.Application} app - egg application
 */
module.exports = app => {
  const { router, controller } = app;

  // web
  router.redirect('/', '/web/home', 302);
  router.get('/web/home', controller.web.home.server);
  router.get('/web/client', controller.web.home.client);

  // API
  // 注册或者登录
  router.post('/v1/user', controller.api.user.loginOrRegister);
  // 获取身份信息
  router.get('/v1/user', controller.api.user.getUserInfo);
  // 获取产品信息
  router.get('/v1/goods', controller.api.goods.getGoods);
  // 修改产品信息
  router.put('/v1/goods', controller.api.goods.insertGoodsInfo);
  // 购物车获取产品详细信息
  router.put('/v1/cart/item', controller.api.shoppingCart.getShoppingCartInfo);
  // 新建地址
  router.post('/v1/address', controller.api.address.createAddress);
  // 修改地址
  router.get('/v1/address/:address_id', controller.api.address.getAddress);
  // 修改地址
  router.put('/v1/address/:address_id', controller.api.address.updateAddress);
  // 删除地址
  router.del('/v1/address/:address_id', controller.api.address.deleteAddress);
  // 删除地址
  router.get('/v1/orgin/:id', controller.api.address.getOrgin);
  // 获取初始订单信息
  router.put('/v1/order', controller.api.order.confrimOrder);
  // 提交订单
  router.post('/v1/order', controller.api.order.submitOrder);
  // 修改订单信息
  router.put('/v1/order/:order_id', controller.api.order.updateOrderInfo);
  // 获取订单历史
  router.get('/v1/order/list', controller.api.order.getOrderList);
  // 获取订单产品
  router.get('/v1/order/:order_id/goods', controller.api.order.getOrderGoods);
};
