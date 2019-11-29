import React, { Component } from 'react'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux'
import { List, Avatar, Button } from 'antd';
import { InputItem, Switch, Stepper, Range } from 'antd-mobile';
import Header from '@webComp/common/header'
import '@web/commoncss/common.css'

class OrderConfirm extends Component {
  constructor(props) {
    super(props)
    
  }

  componentDidMount() {
  }

  render() {
    const {history} = this.props
    return <div className="">
      <Header subTitle="订单提交" history={history} />
      <div>提交订单</div> 
    </div>
    
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
}

const mapDispatchToProps = (dispatch) => {
  return {
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(OrderConfirm)
