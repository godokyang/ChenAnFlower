'use strict';

/**
 * @param {Egg.Application} app - egg application
 */
module.exports = app => {
  const { router, controller } = app;
  // 注册或者登录
  router.post('/v1/user', controller.user.loginOrRegister);
  // 获取身份信息
  router.get('/v1/user', controller.user.getUserInfo);
  // 获取产品信息
  router.get('/v1/goods', controller.goods.getGoods);
  // 修改产品信息
  router.put('/v1/goods', controller.goods.insertGoodsInfo);
  // 购物车获取产品详细信息
  router.put('/v1/cart/item', controller.shoppingCart.getShoppingCartInfo);
  // 新建地址
  router.post('/v1/address', controller.address.createAddress);
  // 修改地址
  router.put('/v1/address/:address_id', controller.address.updateAddress);
  // 删除地址
  router.del('/v1/address/:address_id', controller.address.deleteAddress);
  // 获取初始订单信息
  router.put('/v1/order', controller.order.confrimOrder);
  // 提交订单
  router.post('/v1/order', controller.order.submitOrder);
  // 获取订单历史
  router.get('/v1/order/list', controller.order.getOrderList);
  // 获取订单产品
  router.get('/v1/order/:order_id/goods', controller.order.getOrderGoods);
};
