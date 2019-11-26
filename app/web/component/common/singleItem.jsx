import React, { Component } from 'react'
import { List } from 'antd';
import { Stepper } from 'antd-mobile';

export default class SingleItem extends Component {

  render() {
    const {item} = this.props
    return (
      <List.Item key={item.id}>
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center',
          backgroundColor: 'white',
          padding: '10px'
        }}>
          <img style={{width: '100px',height: '100px'}} src="https://xcimg.szwego.com/1573354279_340020938_1?imageView2/2/format/jpg/q/100" alt=""/>
          <div style={{display: 'flex', flexDirection:'column', justifyContent:'center', alignItems: 'flex-end', marginLeft: '10px'}}>
            <div className="over-two-line" style={{marginBottom: '10px'}}>小雏菊鲜切花！超长花期的花，好养！轻轻松松可以养到一个月[捂脸][捂脸]多彩小雏菊，一扎，陆运16.9元！空运21.9元！多彩小雏菊，两扎，陆运22.9元！空运27.9元！</div>
            <List.Item style={{padding: 0}} extra={<Stepper style={{ width: '100px'}} showNumber size="small" defaultValue={20} />}></List.Item>
          </div>
        </div>
      </List.Item>
    )
  }
}
