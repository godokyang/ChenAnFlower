import React, { Component } from 'react'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux'
import _lodash from 'lodash'
import { Descriptions, List, Button, Cascader, Icon } from 'antd';
import { InputItem, Switch, Stepper, Range } from 'antd-mobile';
import Header from '@webComp/common/header'
import SingleItem from '@webComp/common/singleItem'
import '@web/commoncss/common.css'
import './index.css'

import {axiosConfirm, axiosSetOrgin, setOrgin} from '@webPage/home/store/actions/order'

const options = [
  {
    value: 'zhejiang',
    label: 'Zhejiang',
    children: [
      {
        value: 'hangzhou',
        label: 'Hangzhou'
      }
    ]
  },
  {
    value: 'jiangsu',
    label: 'Jiangsu',
    children: [
      {
        value: 'nanjing',
        label: 'Nanjing'
      }
    ]
  }
];

class OrderConfirm extends Component {
  constructor(props) {
    super(props)
    
  }

  state = {
    text: 'Unselect'
  };

  loadData = (selectedOptions, e) => {
    const targetOption = selectedOptions[selectedOptions.length - 1];
    targetOption.loading = true;
    // this.setState({
    //   text: selectedOptions.map(o => o.label).join(', ')
    // });
    console.log('==============selectedOptions======================');
    console.log(selectedOptions, e);
    console.log('====================================');
    if (this.props.setSubOrgin && this.props.setSubOrgin.length === 0) {
      this.props.setCurOrginAsync('000000', 0)
    } else {
      this.props.setCurOrginAsync(targetOption.ADD_ID, 1)
    }
  };

  componentDidMount() {
    this.props.confirmOrderAsync()
    this.props.setCurOrginAsync('000000', 0)
  }

  render() {
    console.log('==================this.props==================');
    console.log(this.props);
    console.log('====================================');
    const {history, setCurOrgin, confirmOrder, setSubOrgin} = this.props
    const {address, items, sale_total} = confirmOrder
    return <div className="">
      <Header subTitle="订单提交" history={history} />
      <div className="order-context-root">
        <Descriptions bordered >
          <Descriptions.Item label="姓名">{_lodash.get(address, 'receiver', '')}</Descriptions.Item>
          <Descriptions.Item label="电话">{_lodash.get(address, 'contact', '')}</Descriptions.Item>
          <Descriptions.Item label="地区">
            <span>
              {`${_lodash.get(setCurOrgin, 'province.ADD_NAME', '')} ${_lodash.get(setCurOrgin, 'county.ADD_NAME', '')} ${_lodash.get(setCurOrgin, 'city.ADD_NAME', '请添加')}`}
        &nbsp;
              <Cascader 
                fieldNames={{
                  label: 'ADD_NAME',
                  value: 'ADD_ID',
                  children: 'children'
                }}
                changeOnSelect
                size="large"
                options={setSubOrgin || []}
                loadData={this.loadData}
              >
                <Icon type="edit" />
              </Cascader>
            </span>
          </Descriptions.Item>
          <Descriptions.Item label="具体地址">
            {_lodash.get(address, 'detail', '')}
          </Descriptions.Item>
        </Descriptions>
        <List
          dataSource={items}
          renderItem={item => (
            <SingleItem item={item} setCart={this.props.setCart} noControl={true} />
          )}
        >
        </List>
        <div style={{height: '100px'}}></div>
        <div className="order-bottom">
          <div>
              总价: <span>{sale_total}</span>
          </div>
          <Button 
            className="order-button"
            size = "large"
            type = "danger"
            onClick = {() => {
            }}
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
    setCurOrginAsync: bindActionCreators(axiosSetOrgin, dispatch),
    confirmOrderAsync: bindActionCreators(axiosConfirm, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderConfirm)
