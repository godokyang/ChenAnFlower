import React, { Component } from 'react'
import {bindActionCreators} from 'redux'
import { connect } from 'react-redux';
import request from 'framework/request'

import { Icon } from 'antd';
import { TabBar } from 'antd-mobile';
import 'antd-mobile/dist/antd-mobile.css';

import Bed from './Bed';
import ShoppingCart from './ShoppingCart';
import Setup from './Setup';
import webStorage from '@webUtil/storage'
import {getShoppingCart, axiosShoppingcart} from '@webPage/home/store/actions/shoppingcart'
import {storageKey} from '@webConfig'

const BED = 'Bed'
const SHOPPINGCART = 'ShoppingCart'
const SETUP = 'Setup'
let storage = null
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
    
  }

  handleClick(current) {
    this.setState({
      current
    });
    if (current === BED) {
      console.info('Index is loading')
    }
    if (current === SHOPPINGCART) {
      const cartList = storage.get(storageKey.shoppingCart, [])
      this.props.getCart(cartList)
      this.props.getCartItem()
    }
    if (current === SETUP) {
      console.info('SETUP is loading')
    }
  }

  render() {
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
        selected={this.state.current === BED}
        onPress={() => { this.handleClick(BED) }}
      >
        <Bed />
      </TabBar.Item>
      <TabBar.Item
        icon={<Icon style={{ fontSize: '19px' }} type="container" />}
        selectedIcon={<Icon type="container" style={{ fontSize: '19px' }} theme="twoTone" />}
        title="购物车"
        key={SHOPPINGCART}
        badge={0}
        selected={this.state.current === SHOPPINGCART}
        onPress={() => { this.handleClick(SHOPPINGCART) }}
      >
        <ShoppingCart />
      </TabBar.Item>
      <TabBar.Item
        icon={<Icon type="edit" style={{ fontSize: '19px' }} />}
        selectedIcon={<Icon type="edit" style={{ fontSize: '19px' }} theme="twoTone" />}
        title="个人"
        key={SETUP}
        selected={this.state.current === SETUP}
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
    getCart: bindActionCreators(getShoppingCart, dispatch),
    getCartItem: bindActionCreators(axiosShoppingcart, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(Home)