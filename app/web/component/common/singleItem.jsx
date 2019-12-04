import React, { Component } from 'react'
import { List, Popconfirm, Icon, Tooltip } from 'antd';
import { Stepper } from 'antd-mobile';
import { throttle } from '@webUtil'

export default class SingleItem extends Component {

  throttleLocal = null

  componentDidMount() {
    this.throttleLocal = throttle(this.props.getCartItem, 3000)
  }

  cancel(e) {
    console.log(e);
  }

  render() {
    const { item, setCart, removeCart, getCartItem, noControl, showOwner } = this.props
    console.log('====================================');
    console.log(item);
    console.log('====================================');
    return (
      <List.Item key={item.sku}>
        <div style={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
          alignItems: 'center',
          backgroundColor: 'white',
          padding: '10px',
          width: '100%'
        }}>
          <img style={{ width: '120px', height: '120px' }} src={item.images ? item.images.split(',')[0] : ''} alt="" />
          <div style={{ display: 'flex', flexDirection: 'column', justifyContent: 'space-between', height: '120px', alignItems: 'flex-end', marginLeft: '10px' }}>
            {
              noControl ? '' :
                <Popconfirm
                  title="是否确定删除当前产品?"
                  // icon={<Icon type="delete" style={{ color: 'red' }} />}
                  onConfirm={() => {
                    removeCart(item.sku)
                    getCartItem()
                  }}
                  onCancel={this.cancel.bind(this)}
                  okText="确定"
                  cancelText="取消"
                >
                  <Icon style={{ fontSize: '20px' }} type="delete" />
                </Popconfirm>
            }
            {
              showOwner ? 
                <div className="alert" style={{backgroundColor: '#f8ffef'}}>{item.owner.source}: {item.owner.shop_name}</div>
                : ''
            }
            <Tooltip title={item.goods_name}>
              <div className={noControl ? 'over-five-line' : 'over-two-line'}>{item.goods_name}</div>
            </Tooltip>
            
            {
              noControl ? <div className="alert"> <div>单价:{item.goods_price}</div><div>数量:{item.goods_count}</div></div>
                : ''
            }
            {
              noControl ? '' :
                <Stepper
                  style={{ width: '100px' }}
                  showNumber
                  max={100}
                  min={1}
                  size="small"
                  defaultValue={item.quantity}
                  step={1}
                  showNumber
                  onChange={e => {
                    let insertObj = { sku: item.sku, quantity: e }
                    setCart(insertObj)
                    this.throttleLocal()
                    // getCartItem()
                    // this.throttleLocal(getCartItem)()
                  }}
                />
            }
          </div>
        </div>
      </List.Item>
    )
  }
}
