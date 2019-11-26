import React, { Component } from 'react'
import { connect } from 'react-redux'
import { List, Avatar } from 'antd';
import { InputItem, Switch, Stepper, Range, Button } from 'antd-mobile';
import InfiniteScroll from 'react-infinite-scroller';
import SingleItem from '@webComp/common/singleItem'
import * as storage from '@webUtil/storage'
const {Item} = List
import './ShoppingCart.css'
import '@web/commoncss/common.css'

class ShoppingCart extends Component {
  constructor(props) {
    super(props)
    // this.storage = new storage()
  }

  state = {
    data: [{
      id: 1,
      name: 'yangke',
      email: 'godokyang'
    }],
    loading: false,
    hasMore: true
  };

  handleInfiniteOnLoad() {
    console.log('====================================');
    console.log(123);
    console.log('====================================');
  }

  render() {
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
            dataSource={this.state.data}
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

const mapStateToProps = (state) => ({
  
})

const mapDispatchToProps = {
  
}

export default connect(mapStateToProps, mapDispatchToProps)(ShoppingCart)
