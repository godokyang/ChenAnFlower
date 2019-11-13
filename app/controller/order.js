'use strict';

const Controller = require('egg').Controller;

const testData = {
  owner_total: 700,
  agent_total: 700,
  sale_total: 700,
  items: [{
    goods_name: '11月10日云南宏杰鲜花种植基地保鲜红玫，报价更新如下:B级，100扎，21.5元C.级，130扎，19元D级，80扎，16元全部灰霉处理，所有等级枝枝到底，全部基地新鲜采摘，绝无冷藏货，有售后保障，需要的麻烦早点下单，大量有货，每天20点开始配送',
    pro_desc: '测试',
    images: 'https://xcimg.szwego.com/20191110/a1573356924776_0714.jpg?imageView2/2/format/jpg/q/100',
    sale_price: 100,
    agent_price: 100,
    sku: 1000001,
    owner_price: 100,
    top_level: 0,
    show_level: 0,
    owner_shop_id: 'A201902190956237250142523',
    quantity: 7,
  }, {
    goods_name: '10月10日云南宏杰鲜花种植玫瑰花基地勿忘我报价降价！！！最适合做干花的鲜花！配色超赞，花期超长！代理同价！套餐一:混搭勿忘我1000克收到除去损耗实际重量在800到900克送随机配草超值价:23元中通陆运包邮套餐二:混搭勿忘我500克+配草+薰衣草一扎（80到90支左右薰衣草）实惠价:29元中通陆运包邮两个套餐代理同价代理同价任意一个套餐++++10元带走一个可爱小铁桶（铁通颜色随机发不指定）上海，北京+++++3元海南，吉林，辽宁，黑龙江+++7元甘肃，宁夏，青海，内蒙古++++12元勿忘我运输途中有水份蒸发损耗，实际收到重量会减少150克左右，轻微掉苞情况不售后！薰衣草是干花掉苞情况不售后！勿忘我活动可以持续两到三天，数量不多卖完下架',
    pro_desc: null,
    images: 'https://xcimg.szwego.com/20191012/a1570860398793_5317.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860399536_4626.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860399708_3048.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860399895_6530.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860400393_8125.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860400566_0806.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860400749_2621.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860400917_3285.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191012/a1570860401114_1723.jpg?imageView2/2/format/jpg/q/100',
    sale_price: 0,
    agent_price: 0,
    sku: 1000002,
    owner_price: 0,
    top_level: 0,
    show_level: 0,
    owner_shop_id: 'A201902190956237250142523',
    quantity: 1,
  }, {
    goods_name: '快递费参考图片',
    pro_desc: null,
    images: 'https://xcimg.szwego.com/20191102/a1572664751964_6584.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191102/a1572664752641_6636.jpg?imageView2/2/format/jpg/q/100,https://xcimg.szwego.com/20191102/a1572664753383_1387.jpg?imageView2/2/format/jpg/q/100',
    sale_price: 0,
    agent_price: 0,
    sku: 1000003,
    owner_price: 0,
    top_level: 0,
    show_level: 0,
    owner_shop_id: 'A201902190956237250142523',
    quantity: 1,
  }, {
    goods_name: '单头百合！实拍视频，实拍品质！耐运输，好养的花！推荐百合！',
    pro_desc: null,
    images: 'https://xcimg.szwego.com/1573354841_2497443809_1?imageView2/2/format/jpg/q/100',
    sale_price: 0,
    agent_price: 0,
    sku: 1000004,
    owner_price: 0,
    top_level: 0,
    show_level: 0,
    owner_shop_id: 'A201810141536512620169423',
    quantity: 3,
  }, {
    goods_name: '单头百合！品质看得见，百合比较好养！如果喜欢花那么一定不要错过它！单头百合，颜色随机发，一扎10枝！一扎，陆运19.9元！两扎，陆运29.9元！',
    pro_desc: null,
    images: 'https://xcimg.szwego.com/1573354717_2679216345_1?imageView2/2/format/jpg/q/100',
    sale_price: 0,
    agent_price: 0,
    sku: 1000006,
    owner_price: 0,
    top_level: 0,
    show_level: 0,
    owner_shop_id: 'A201810141536512620169423',
    quantity: 7,
  }],
  address: {
    detail: '测试不打',
    contact: '1877777772',
    receiver: '杨科1',
    customer_id: 10000000001,
    address_id: '088eb780-045a-11ea-a4ce-5742e1169183',
    ADD_ID: '1558',
  },
};
class OrderCartController extends Controller {
  async confrimOrder() {
    const { ctx } = this;
    const result = await ctx.service.order.confirmOrder([
      { sku: 1000001, quantity: 7 },
      { sku: 1000002, quantity: 1 },
      { sku: 1000003, quantity: 1 },
      { sku: 1000004, quantity: 3 },
      { sku: 1000006, quantity: 7 },
    ]);
    ctx.body = result;
  }

  async submitOrder() {
    const { ctx } = this;
    const result = await ctx.service.order.submitOrder(testData);
    ctx.body = result;
  }

  async getOrderList() {
    const { ctx } = this;
    const result = await ctx.service.order.getOrderList();
    ctx.body = result;
  }

  async getOrderGoods() {
    const { ctx } = this;
    const result = await ctx.service.order.getOrderGoods();
    ctx.body = result;
  }
}

module.exports = OrderCartController;
