import React, { Component } from 'react'
import { connect } from 'react-redux'
import {Link} from 'react-router-dom'
import {bindActionCreators} from 'redux'
import { List, Avatar, Button } from 'antd';
import { InputItem, Switch, Stepper, Range } from 'antd-mobile';
import InfiniteScroll from 'react-infinite-scroller';
import SingleItem from '@webComp/common/singleItem'
const {Item} = List
import './ShoppingCart.css'
import '@web/commoncss/common.css'

import {getShoppingCart, axiosShoppingcart, setShoppingCart, removeShoppingCart} from '@webPage/home/store/actions/shoppingcart'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'

class ShoppingCart extends Component {
  constructor(props) {
    super(props)
    
  }

  componentDidMount() {
    this.props.getCart()
    this.props.getCartItem()
  }

  state = {
    loading: false,
    hasMore: true
  };



  handleInfiniteOnLoad() {
  }

  render() {
    const {agent_total,owner_total,sale_total,items} = this.props.getShoppingCartItem
    const {tabHandle} = this.props
    return (
      <div className="demo-infinite-container">
        <div>
          <List
            dataSource={items}
            renderItem={item => (
              <SingleItem item={item} setCart={this.props.setCart} getCartItem={this.props.getCartItem} removeCart={this.props.removeCart} />
            )}
          >
            {this.state.loading && this.state.hasMore && (
              <div className="demo-loading-container">
                <Spin />
              </div>
            )}
          </List>
          <div style={{height: '100px'}}></div>
        </div>
        {
          tabHandle && tabHandle === 'ShoppingCart' ? 
            <div className="cart-bottom">
              <div>
              总价: <span>{sale_total}</span>
              </div>
              <Button 
                className="cart-button"
                size = "large"
                type = "danger"
                // onClick = {() => {
                // }}
              >
                
                <Link to='/web/orderConfirm'>购买</Link>
              </Button>
            </div>
            :''
        }
        
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
}

const mapDispatchToProps = (dispatch) => {
  return {
    setCart: bindActionCreators(setShoppingCart, dispatch),
    getCart: bindActionCreators(getShoppingCart, dispatch),
    removeCart: bindActionCreators(removeShoppingCart, dispatch),
    getCartItem: bindActionCreators(axiosShoppingcart, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ShoppingCart)
