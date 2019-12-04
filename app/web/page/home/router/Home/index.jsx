import React, { Component } from 'react'
import {bindActionCreators} from 'redux'
import { connect } from 'react-redux';
import request from 'framework/request'

import { Icon } from 'antd';
import { TabBar } from 'antd-mobile';
import 'antd-mobile/dist/antd-mobile.css';
import 'antd/dist/antd.css';

import Bed from './Bed';
import ShoppingCart from './ShoppingCart';
import Setup from './Setup';
import {getShoppingCart, removeAllShoppingCart, axiosShoppingcart} from '@webPage/home/store/actions/shoppingcart'
import {setTab} from '@webPage/home/store/actions/home'
import {withRouter} from 'react-router-dom';

const BED = 'Bed'
const SHOPPINGCART = 'ShoppingCart'
const SETUP = 'Setup'

class Home extends Component {
  constructor(props) {
    super(props);
    this.state = { current: BED };
  }

  static asyncData(context, route) {
    return request.get('/v1/goods', {}, context.state).then(res => {
      return {
        goodsHandle: {
          goodsList: res.data.data.goods
        }
      };
    });
  }

  componentDidMount() {
    // this.props.removeAllCart()
    this.props.setTab(BED)
  }

  handleClick(current) {
    this.props.setTab(current)
    this.props.getCart()
    if (current === BED) {
      console.info('Index is loading')
    }
    if (current === SHOPPINGCART) {
      // const cartList = webStorage.get(storageKey.shoppingCart, [])
      this.props.getCartItem()
    }
    if (current === SETUP) {
      console.info('SETUP is loading')
    }
  }

  render() {
    const cartCount = this.props.shoppingcartCountHandle ? this.props.shoppingcartCountHandle.length : 0;
    const currentTab = this.props.tabHandle
    return <TabBar
      unselectedTintColor="#949494"
      tintColor="#33A3F4"
      barTintColor="white"
      hidden={false}
      tabBarPosition="bottom"
    >
      <TabBar.Item
        title="花圃"
        key={BED}
        icon={<Icon type="home" style={{ fontSize: '19px' }} />}
        selectedIcon={<Icon type="home" style={{ fontSize: '19px' }} theme="twoTone" />}
        selected={currentTab === BED}
        onPress={() => { this.handleClick(BED) }}
      >
        <Bed />
      </TabBar.Item>
      <TabBar.Item
        icon={<Icon style={{ fontSize: '19px' }} type="container" />}
        selectedIcon={<Icon type="container" style={{ fontSize: '19px' }} theme="twoTone" />}
        title="购物车"
        key={SHOPPINGCART}
        badge={cartCount}
        selected={currentTab === SHOPPINGCART}
        onPress={() => { this.handleClick(SHOPPINGCART) }}
      >
        <ShoppingCart />
      </TabBar.Item>
      <TabBar.Item
        icon={<Icon type="edit" style={{ fontSize: '19px' }} />}
        selectedIcon={<Icon type="edit" style={{ fontSize: '19px' }} theme="twoTone" />}
        title="个人"
        key={SETUP}
        selected={currentTab === SETUP}
        onPress={() => { this.handleClick(SETUP) }}
      >
        <Setup />
      </TabBar.Item>
    </TabBar>
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state);
};

const mapDispatchToProps = (dispatch) => {
  return {
    setTab: bindActionCreators(setTab, dispatch),
    removeAllCart: bindActionCreators(removeAllShoppingCart, dispatch),
    getCart: bindActionCreators(getShoppingCart, dispatch),
    getCartItem: bindActionCreators(axiosShoppingcart, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(withRouter(Home))