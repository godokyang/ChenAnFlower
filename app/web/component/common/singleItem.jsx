import React, { Component } from 'react'
import { List } from 'antd';
import { Stepper } from 'antd-mobile';

export default class SingleItem extends Component {

  render() {
    const {item} = this.props
    return (
      <List.Item key={item.sku}>
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center',
          backgroundColor: 'white',
          padding: '10px'
        }}>
          <img style={{width: '100px',height: '100px'}} src={item.images.split(',')[0]} alt=""/>
          <div style={{display: 'flex', flexDirection:'column', justifyContent:'center', alignItems: 'flex-end', marginLeft: '10px'}}>
            <div className="over-two-line" style={{marginBottom: '10px'}}>{item.goods_name}</div>
            <List.Item style={{padding: 0}} extra={<Stepper style={{ width: '100px'}} showNumber size="small" defaultValue={item.quantity} />}></List.Item>
          </div>
        </div>
      </List.Item>
    )
  }
}
