import React, { Component } from 'react'
import { connect } from 'react-redux'
import { Avatar, message, List, Tag, Descriptions } from 'antd'

import _lodash from 'lodash'
import * as api from '@webApi'
import Header from '@webComp/common/header'
import SingleItem from '@webComp/common/singleItem'


export class OrderDetail extends Component {

  state = {
    theme: {},
    orderDetail: [],
    address: {}
  }

  componentDidMount() {
    this.getOrderDetail()
  }

  async getOrderDetail() {
    const {order_id, address_id} = this.props.location.query
    const orderRes = await api.getOrderListGoods(order_id)
    const addressRes = await api.getAddressById(address_id)
    let orderDetail = _lodash.get(orderRes, 'data.data.list', {})
    let address = _lodash.get(addressRes, 'data.data.address', {})
    this.setState({
      theme: this.props.location.query,
      orderDetail,
      address
    })
  }

  render() {
    const { history } = this.props
    const {theme, address, orderDetail} = this.state
    return (
      <div>
        <Header subTitle="订单详情" history={history} />
        <div className="order-context-root" style={{marginTop: '65px'}}>
          <Descriptions bordered >
            <Descriptions.Item label="姓名">{_lodash.get(address, 'receiver', '')}</Descriptions.Item>
            <Descriptions.Item label="电话">{_lodash.get(address, 'contact', '')}</Descriptions.Item>
            <Descriptions.Item label="地区">{`${_lodash.get(address, 'orgin.province.ADD_NAME', '请添加')} ${_lodash.get(address, 'orgin.county.ADD_NAME', '')} ${_lodash.get(address, 'orgin.city.ADD_NAME', '')}`}</Descriptions.Item>
            <Descriptions.Item label="具体地址">{_lodash.get(address, 'detail', '')}</Descriptions.Item>
            <Descriptions.Item label="金额">{theme.payment_total}</Descriptions.Item>
          </Descriptions>
          <List
            dataSource={orderDetail}
            renderItem={item => (
              <SingleItem item={item} noControl={true} />
            )}
          >
          </List>
        </div>
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

export default connect(mapStateToProps, mapDispatchToProps)(OrderDetail)

