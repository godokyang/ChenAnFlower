import React, { Component } from 'react'
import { Route, Link, Switch } from 'react-router-dom';
import { connect } from 'react-redux';
import request from 'framework/request'

import {Icon} from 'antd';
import { TabBar } from 'antd-mobile';
import 'antd-mobile/dist/antd-mobile.css';

import Bed from './Bed';
import Article from './Article';
import Setup from './Setup';
import {loadGoods} from '../../store/actions/goods'

const BED = 'Bed'
const SHOPPINGCART = 'ShoppingCart'
const SETUP = 'Setup'

class Home extends Component {
  constructor(props) {
    super(props);
    this.state = { current: props.url || BED };
  }

  static asyncData(context, route) {
    return request.get('/v1/goods', context.state).then(res => {
      return res.data.data;
    });
  }

  handleClick(current) {
    this.setState({
      current
    });
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
        icon={<Icon type="home" style={{fontSize: '19px'}} />}
        selectedIcon={<Icon type="home" style={{fontSize: '19px'}} theme="twoTone" />}
        selected={this.state.current === BED}
        onPress={() => {this.handleClick(BED)}}
      >
        <Bed />
      </TabBar.Item>
      <TabBar.Item
        icon={<Icon style={{fontSize: '19px'}} type="container" />}
        selectedIcon={<Icon type="container" style={{fontSize: '19px'}} theme="twoTone" />}
        title="购物车"
        key={SHOPPINGCART}
        selected={this.state.current === SHOPPINGCART}
        onPress={() => {this.handleClick(SHOPPINGCART)}}
      >
        <Article />
      </TabBar.Item>
      <TabBar.Item
        icon={<Icon type="edit" style={{fontSize: '19px'}} />}
        selectedIcon={<Icon type="edit" style={{fontSize: '19px'}} theme="twoTone" />}
        title="个人"
        key={SETUP}
        selected={this.state.current === SETUP}
        onPress={() => {this.handleClick(SETUP)}}
      >
        <Setup />
      </TabBar.Item>
    </TabBar>
  }
}

const mapStateToProps = (state) => {
  return state;
};

export default connect(mapStateToProps)(Home);