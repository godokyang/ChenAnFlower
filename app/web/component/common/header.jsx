import React, { Component } from 'react'
import { PageHeader } from 'antd';

export default class Header extends Component {

  render() {
    const {history, subTitle} = this.props
    return <PageHeader
      style={{
        border: '1px solid rgb(235, 237, 240)',
        position: 'fixed',
        top: 0,
        left: 0,
        zIndex: 9990,
        width: '100%',
        backgroundColor: 'white',
        height: '65px'
      }}
      onBack={() => history.goBack()}
      title="晨安&花"
      subTitle={subTitle}
    />
  }
}
