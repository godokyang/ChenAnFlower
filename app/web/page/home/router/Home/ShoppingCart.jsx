import React, { Component } from 'react'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux'
import { List, Avatar } from 'antd';
import { InputItem, Switch, Stepper, Range, Button } from 'antd-mobile';
import InfiniteScroll from 'react-infinite-scroller';
import SingleItem from '@webComp/common/singleItem'
const {Item} = List
import './ShoppingCart.css'
import '@web/commoncss/common.css'

import {getShoppingCart, axiosShoppingcart} from '@webPage/home/store/actions/shoppingcart'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'

class ShoppingCart extends Component {
  constructor(props) {
    super(props)
    
  }

  componentDidMount() {
    // const cartList = webStorage.get(storageKey.shoppingCart, [])
    // this.props.getCartItem(cartList)
  }

  state = {
    loading: false,
    hasMore: true
  };



  handleInfiniteOnLoad() {
  }

  render() {
    const {agent_total,owner_total,sale_total,items} = this.props.getShoppingCartItem
    return (
      <div className="demo-infinite-container">
        <InfiniteScroll
          initialLoad={true}
          pageStart={0}
          loadMore={this.handleInfiniteOnLoad}
          // hasMore={!this.state.loading && this.state.hasMore}
          useWindow={false}
        >
          <List
            dataSource={items}
            renderItem={item => (
              <SingleItem item={item} />
            )}
          >
            {this.state.loading && this.state.hasMore && (
              <div className="demo-loading-container">
                <Spin />
              </div>
            )}
          </List>
        </InfiniteScroll>
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
}

const mapDispatchToProps = (dispatch) => {
  return {
    getCart: bindActionCreators(getShoppingCart, dispatch),
    getCartItem: bindActionCreators(axiosShoppingcart, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(ShoppingCart)
