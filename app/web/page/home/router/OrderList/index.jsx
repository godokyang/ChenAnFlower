import React, { Component } from 'react'
import { connect } from 'react-redux'
import {Link} from 'react-router-dom'
import { Avatar, message, List, Tag, Descriptions } from 'antd'
import { WingBlank, WhiteSpace, Card } from 'antd-mobile'

import InfiniteScroll from 'react-infinite-scroller';
import _lodash from 'lodash'
import * as api from '@webApi'
import Header from '@webComp/common/header'
import {getMyDate} from '@webUtil'

class ListItem extends Component {

  render() {
    const {data, order_status_mapping, payment_mapping, user_info} = this.props
    return <div style={{width: '100%'}}>
      <Card full>
        <Card.Header
          title={<Tag color="#f50">{_lodash.find(order_status_mapping, function(o){return String(o.order_status_id) === String(data.order_status)}).order_status_desc}</Tag>}
          // thumb="https://gw.alipayobjects.com/zos/rmsportal/MRhHctKOineMbKAZslML.jpg"
          extra={<Avatar style={{ backgroundColor: '#7265e6', verticalAlign: 'middle' }} size="large">
            {user_info.user_name}
          </Avatar>}
        />
        <Card.Body >
          <Descriptions bordered size="small">
            {/* <Descriptions.Item label="订单编号">{data.order_id}</Descriptions.Item> */}
            <Descriptions.Item label="支付方式">{_lodash.find(payment_mapping, function(o){return String(o.payment_way_id) === String(data.payment_way)}).payment_way_desc}</Descriptions.Item>
            <Descriptions.Item label="应付金额">{data.payment_total}</Descriptions.Item>
            <Descriptions.Item label="下单时间">{getMyDate(data.create_time)}</Descriptions.Item>
          </Descriptions>
        </Card.Body>
        <Card.Footer extra={<Link to={{pathname: '/web/orderDetail', query: data}}>查看详情</Link>} />
      </Card>
    </div>
  }
}

export class OrderList extends Component {

  state = {
    loading: false,
    hasMore: true,
    list: [],
    order_status_mapping: {},
    payment_mapping: {},
    user_info: {}
  }

  componentWillMount() {
    this.getOrderList().then(list => {
      this.setState(Object.assign({}, list))
    })
  }

  async getOrderList() {
    try {
      let res = await api.getOrderList()
      let orderListData = _lodash.get(res, 'data.data.order_list', [])
      return orderListData
    } catch (error) {
      return []
    }
  }

  handleInfiniteOnLoad = () => {
    let { list } = this.state;
    this.setState({
      loading: true
    });
    if (list.length > 14) {
      message.warning('Infinite List loaded all');
      this.setState({
        hasMore: false,
        loading: false
      });
      return;
    }
    this.getOrderList(res => {
      list = list.concat(res.list);
      this.setState(this.setState(Object.assign({}, list, {loading: false})));
    });
  };

  render() {
    const { history } = this.props
    const { list, order_status_mapping, payment_mapping, user_info } = this.state
    return (
      <div>
        <Header subTitle="订单列表" history={history} />
        <InfiniteScroll
          style={{marginTop: '65px'}}
          initialLoad={false}
          pageStart={0}
          loadMore={this.handleInfiniteOnLoad}
          hasMore={!this.state.loading && this.state.hasMore}
          useWindow={false}
        >
          <List
            // header={<div>Header</div>}
            // footer={<div>Footer</div>}
            bordered
            dataSource={list}
            renderItem={item => (
              <List.Item>
                <ListItem user_info={user_info} payment_mapping={payment_mapping} order_status_mapping={order_status_mapping} data={item} />
              </List.Item>
            )}
          />
        </InfiniteScroll>
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {}
}

const mapDispatchToProps = {
  // return {}
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderList)

