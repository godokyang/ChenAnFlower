import React, { Component } from 'react'
// import {history} from 'react-router'
import { PageHeader } from 'antd';
import { Stepper } from 'antd-mobile';

export default class Header extends Component {

  render() {
    console.log(this.props)
    const {history, subTitle} = this.props
    return <PageHeader
      style={{
        border: '1px solid rgb(235, 237, 240)'
      }}
      onBack={() => history.goBack()}
      title="晨安&花"
      subTitle={subTitle}
    />
  }
}
