import React, { Component } from 'react'
import { connect } from 'react-redux'
import { bindActionCreators } from 'redux'
import _lodash from 'lodash'
import { Descriptions, List, Button, Cascader, Icon, Input, Spin, message } from 'antd';
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'
import Header from '@webComp/common/header'
import SingleItem from '@webComp/common/singleItem'
import * as api from '@webApi'
import '@web/commoncss/common.css'
import './index.css'
const { TextArea } = Input

import { axiosConfirm, axiosSetOrgin, setOrgin, submitPartOrder } from '@webPage/home/store/actions/order'
import { removeAllShoppingCart } from '@webPage/home/store/actions/shoppingcart'

message.config({
  top: '100px'
})

class OrderConfirm extends Component {
  constructor(props) {
    super(props)

  }

  state = {
    options: [],
    popupVisible: false,
    loading: false
  };

  setOrginByState = async (id, type) => {
    try {
      let orgin = await this.getLeafOrgin(id, type)
      this.setState({
        options: orgin
      })
    } catch (error) {
      throw error
    }
  }

  getLeafOrgin = async (id, type) => {
    try {
      let res = await api.getOrgin(id, { params: { type } })
      return res.data.data.orgin.map((item) => {
        return Object.assign(item, { isLeaf: false })
      })
    } catch (error) {
      throw error
    }
  }

  onChange = async (value, selectedOptions) => {
    const targetOption = selectedOptions[selectedOptions.length - 1];
    targetOption.loading = true;
    try {
      targetOption.loading = false;
      if (!targetOption.children || (targetOption.children === 0 && !targetOption.isLeaf)) {
        let orgin = await this.getLeafOrgin(targetOption.ADD_ID, 1)
        targetOption.children = orgin
        targetOption.isLeaf = true
      }
      this.setState({
        options: [...this.state.options]
      })
      if (targetOption.children && targetOption.children.length === 0) {
        const {address} = this.props.confirmOrder
        address.ADD_ID = targetOption.ADD_ID
        this.props.setCurOrign(selectedOptions)
        this.setState({
          popupVisible: false
        })
      }
    } catch (error) {
      throw error
    }
  };

  inputChange = (e) => {
    const changed = this.props.confirmOrder
    changed.address[e.target.id] = e.target.value
    this.props.submitPartOrder(changed)
  }

  submitOrder = async () => {
    this.setState({
      loading: true
    })
    const postData = this.props.confirmOrder
    try {
      await api.submitOrder(postData)
      this.setState({
        loading: false
      })
      message.info('提交成功！')
      this.props.removeShoppingCart()
      this.props.history.replace('/web/orderList')
    } catch (error) {
      this.setState({
        loading: false
      })
      message.info('提交失败！')
    }
  }

  componentDidMount() {
    this.props.confirmOrderAsync()
  }

  componentWillMount() {
    this.setOrginByState('000000', 0)
  }

  render() {
    const { history, setCurOrgin, confirmOrder } = this.props
    const { address, items, sale_total } = confirmOrder
    return <div>
      {
        this.state.loading ? <Spin className='loading' /> : ''
      }
      {
        this.state.error ? <Alert message={this.state.error} type="success" showIcon /> : ''
      }
      <Header subTitle="订单提交" history={history} />
      <div className="order-context-root" style={{marginTop: '65px'}}>
        <Descriptions bordered >
          <Descriptions.Item label="姓名">
            <Input
              value={_lodash.get(address, 'receiver', '')}
              id='receiver'
              onChange={this.inputChange}
              placeholder="请输入收货人姓名"
              maxLength={12}
            />
          </Descriptions.Item>
          <Descriptions.Item label="电话">
            <Input
              id="contact"
              value={_lodash.get(address, 'contact', '')}
              onChange={this.inputChange}
              placeholder="请输入收货人电话"
              maxLength={20}
              type='number'
            />
          </Descriptions.Item>
          <Descriptions.Item label="地区">
            <span>
              {`${_lodash.get(setCurOrgin, 'province.ADD_NAME', '')} ${_lodash.get(setCurOrgin, 'county.ADD_NAME', '')} ${_lodash.get(setCurOrgin, 'city.ADD_NAME', '')}`}
              &nbsp;
              <Cascader
                fieldNames={{
                  label: 'ADD_NAME',
                  value: 'ADD_ID',
                  children: 'children'
                }}
                popupVisible={this.state.popupVisible}
                changeOnSelect
                size="large"
                options={this.state.options}
                onChange={this.onChange}
              >
                <Icon onClick={() => { this.setState({ popupVisible: !this.state.popupVisible }) }} type="edit" />
              </Cascader>
            </span>
          </Descriptions.Item>
          <Descriptions.Item label="具体地址">
            <TextArea
              id="detail"
              value={_lodash.get(address, 'detail', '')}
              maxLength={200}
              onChange={this.inputChange}
            />
          </Descriptions.Item>
        </Descriptions>
        <List
          dataSource={items}
          renderItem={item => (
            <SingleItem item={item} setCart={this.props.setCart} noControl={true} />
          )}
        >
        </List>
        <div style={{ height: '100px' }}></div>
        <div className="order-bottom">
          <div>
            总价: <span>{sale_total}</span>
          </div>
          <Button
            className="order-button"
            size="large"
            type="danger"
            onClick={this.submitOrder}
          >
            购买
            {/* <Link to='/web/orderConfirm'>购买</Link> */}
          </Button>
        </div>
      </div>
    </div>

  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
}

const mapDispatchToProps = (dispatch) => {
  return {
    submitPartOrder: bindActionCreators(submitPartOrder, dispatch),
    setCurOrign: bindActionCreators(setOrgin, dispatch),
    setCurOrginAsync: bindActionCreators(axiosSetOrgin, dispatch),
    confirmOrderAsync: bindActionCreators(axiosConfirm, dispatch),
    removeShoppingCart: bindActionCreators(removeAllShoppingCart, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderConfirm)
