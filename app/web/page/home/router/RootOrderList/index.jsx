import React, { Component } from 'react'
import { connect } from 'react-redux'
import {Link} from 'react-router-dom'
import { Avatar, message, List, Tag, Descriptions, Select, Icon, Button } from 'antd'
import { WingBlank, WhiteSpace, Card } from 'antd-mobile'

import InfiniteScroll from 'react-infinite-scroller';
import _lodash from 'lodash'
import * as api from '@webApi'
import Header from '@webComp/common/header'
import {getMyDate} from '@webUtil'

class ListItem extends Component {
  constructor(props) {
    super(props)
  }

  state = {
    isError: false
  }

  render() {
    const {data, order_status_mapping, payment_mapping, user_info} = this.props
    data.showOwner = true
    return <div style={{width: '100%'}}>
      <Card full>
        <Card.Header
          title={<Select 
            defaultValue={_lodash.find(order_status_mapping, function(o){return String(o.order_status_id) === String(data.order_status)}).order_status_desc} 
            style={{ width: 120 }} 
            suffixIcon={this.state.isError ? <Icon type="exclamation-circle" theme="twoTone" twoToneColor="red" /> : ''}
            // suffixIcon={<Icon type="exclamation-circle" theme="twoTone" twoToneColor="red" />}
            onChange={(value) => {
              api.updateOrderInfo(data.order_id, {order_status: value})
                .then(res => {
                  message.info(`更改${data.customer_name}的订单状态成功`, 1)
                  this.setState({
                    isError: false
                  })
                })
                .catch(error => {
                  message.info(`更改${data.customer_name}的订单状态失败`, 1)
                  this.setState({
                    isError: true
                  })
                })
            }}>
            {
              order_status_mapping.map((item, index) => {
                return <Select.Option key={index} value={item.order_status_id}>{item.order_status_desc}</Select.Option>
              })
            }
          </Select>}
          // thumb="https://gw.alipayobjects.com/zos/rmsportal/MRhHctKOineMbKAZslML.jpg"
          extra={<Avatar style={{ backgroundColor: '#7265e6', verticalAlign: 'middle' }} size="large">
            {data.customer_name}
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

export class RootOrderList extends Component {

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

  async getOrderList(params = {}) {
    try {
      let res = await api.getOrderList(params)
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
    // if (list.length > 14) {
    //   message.warning('Infinite List loaded all');
    //   this.setState({
    //     hasMore: false,
    //     loading: false
    //   });
    //   return;
    // }
    this.getOrderList({last_id: list[list.length-1].order_number}).then(res => {
      list = list.concat(res.list);
      this.setState({list: list, loading: false});
      if (res.list.length < 10) {
        this.setState({
          hasMore: false,
          loading: false
        });
        message.warning('没有更多了');
      }
    });
  };

  render() {
    const { history } = this.props
    const { list, order_status_mapping, payment_mapping, user_info } = this.state
    const loadMore =
      !this.state.loading && this.state.hasMore ? (
        <div
          style={{
            textAlign: 'center',
            padding: '12px'
          }}
        >
          <Button onClick={this.handleInfiniteOnLoad}>加载更多</Button>
        </div>
      ) : null;
    return (
      <div>
        <Header subTitle="订单列表" history={history} />
        {/* <InfiniteScroll
          style={{marginTop: '65px'}}
          pageStart={0}
          useWindow={false}
        > */}
        <List
          // header={<div>Header</div>}
          // footer={<div>Footer</div>}
          style={{marginTop: '65px'}}
          loadMore={loadMore}
          hasMore={!this.state.loading && this.state.hasMore}
          bordered
          dataSource={list}
          renderItem={item => (
            <List.Item>
              <ListItem user_info={user_info} payment_mapping={payment_mapping} order_status_mapping={order_status_mapping} data={item} />
            </List.Item>
          )}
        />
        {/* </InfiniteScroll> */}
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

export default connect(mapStateToProps, mapDispatchToProps)(RootOrderList)

