'use strict';
const Controller = require('egg').Controller;

class HomeController extends Controller {
  async server() {
    const { ctx } = this;
    // home.js对应webpack.config.js中的entry字段
    await ctx.render('home.js', { 
      url: ctx.url,
      side: 'server' 
    });
  }

  async client() {
    const { ctx } = this;
    // renderClient 前端渲染，Node层只做 layout.html和资源依赖组装，渲染交给前端渲染。与服务端渲染的差别你可以通过查看运行后页面源代码即可明白两者之间的差异
    await ctx.renderClient('home.js', { 
      url: ctx.url,
      side: 'client' 
    });
  }
}

module.exports = HomeController;
