/* eslint-disable func-style */
import React, { Component } from 'react'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux'
import { ListView, Grid } from 'antd-mobile';
import { Select, Button } from 'antd';
import webStorage from '@webUtil/storage';
const { Option } = Select;
import _lodash from 'lodash'
import 'antd-mobile/dist/antd-mobile.css';
import './goodsList.css'

import {showBigPics, axiosGoods} from '@webPage/home/store/actions/goods'
import {addShoppingCart} from '@webPage/home/store/actions/shoppingcart'
import {storageKey} from '@webConfig'

const NUM_ROWS = 5;

function genData(pIndex = 0) {
  const dataBlob = {};
  for (let i = 0; i < NUM_ROWS; i++) {
    const ii = (pIndex * NUM_ROWS) + i;
    dataBlob[`${ii}`] = `row - ${ii}`;
  }
  return dataBlob;
}

class GoodsList extends React.Component {
  constructor(props) {
    super(props);
    const dataSource = new ListView.DataSource({
      rowHasChanged: (row1, row2) => row1 !== row2
    });
    
    this.state = {
      dataSource,
      isLoading: true
    };
  }

  componentDidMount() {
    // you can scroll to the specified position
    // setTimeout(() => this.lv.scrollTo(0, 120), 800);

    // simulate initial Ajax
    setTimeout(() => {
      this.rData = genData();
      this.setState({
        dataSource: this.state.dataSource.cloneWithRows(this.rData),
        isLoading: true
      });
    }, 600);
  }

  // If you use redux, the data maybe at props, you need use `componentWillReceiveProps`
  componentWillReceiveProps(nextProps) {
    if (_lodash.get(nextProps, 'goodsHandle.goodsList', []) !== _lodash.get(this.props, 'goodsHandle.goodsList', [])) {
      let newGoodsList = _lodash.get(nextProps, 'goodsHandle.goodsList')
      this.setState({
        dataSource: this.state.dataSource.cloneWithRows(newGoodsList)
      });
    }
  }

  onEndReached = async (event) => {
    // load new data
    // hasMore: from backend data, indicates whether it is the last page, here is false
    const lastGoods = _lodash.last(_lodash.get(this.props, 'goodsHandle.goodsList', [{sku: null}])).sku
    await this.props.axiosGoods({
      params: {last_id: lastGoods}
    })
  }

  render() {
    const separator = (sectionID, rowID) => (
      <div
        key={`${sectionID}-${rowID}`}
        style={{
          backgroundColor: '#F5F5F9',
          height: 8,
          borderTop: '1px solid #ECECED',
          borderBottom: '1px solid #ECECED'
        }}
      />
    );
    
    const data = _lodash.get(this.props, 'goodsHandle.goodsList', [])
    let index = data.length - 1;
    const row = (rowData, sectionID, rowID) => {
      if (index < 0) {
        index = data.length - 1;
      }
      const obj = data[index--];
      const images = obj.images.split(',').map((item) => {
        return { icon: item }
      })
      return (
        <div key={rowID} style={{ padding: '0 15px' }}>
          <div
            style={{
              lineHeight: '15px',
              color: '#888',
              fontSize: 13,
              padding: '10px',
              borderBottom: '1px solid #F6F6F6'
            }}
          >{obj.des || `晨安&花${obj.sku}`}</div>
          <div style={{ display: '-webkit-box', display: 'flex', padding: '0', flexDirection: 'column' }}>
            <Grid data={images}
              columnNum={images.length < 4 ? images.length : 4}
              itemStyle={{ maxWidth: '150px', background: 'rgba(0,0,0,.05)', paddingTop: 0 }}
              className="not-square-grid"
              hasLine={false}
              // square={false}
              renderItem={dataItem => (
                <div style={{ width: '100%', height: '100%' }}>
                  <span style={{ height: '100%', verticalAlign: 'middle', display: 'inline-block' }}></span>
                  <img src={dataItem.icon} style={{ width: '100%', verticalAlign: 'middle', height: 'auto' }} alt="" />
                </div>

              )}
              onClick={(el, index) =>{
                const bigPics = [...images]
                this.props.showBigPics({
                  bigPics,
                  index
                })
              }}
            />
            <div style={{ lineHeight: 1 }}>
              <div style={{ fontWeight: 'bold', fontSize: '14px', padding: '10px', lineHeight: '20px' }}>{obj.goods_name}</div>
              <div style={{ marginBottom: '16px', marginLeft: '7px', display: 'flex', flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' }}>
                <div>¥<span style={{ fontSize: '30px', color: '#FF6E27' }}>{obj.sale_price}</span></div>
                <Button 
                  type="danger" 
                  shape="circle" 
                  icon="shopping-cart"
                  size="large"
                  // activestyle={false}
                  onClick={() => {
                    this.props.addCart(obj.sku)
                  }}
                />
              </div>
            </div>
          </div>
        </div>
      );
    };
    return (
      <div style={{width: '100%',height:'100%',position: 'absolute',top: 0, left: 0,display: 'flex', flexDirection: 'column',alignItems: 'center',justifyContent: 'flex-start'}}>
        <div className="sticky-header">
          <h1 style={{padding:0, margin:0}}>晨安&花</h1>
          <Select defaultValue="lucy" style={{ width: 120 }} onChange={(value) => {
            console.log(value);
          }}>
            <Option value="jack">玫瑰</Option>
            <Option value="lucy">百合</Option>
            <Option value="disabled" disabled>郁金香</Option>
            <Option value="Yiminghe">其他</Option>
          </Select>
        </div>
        <ListView
          ref={el => this.lv = el}
          dataSource={this.state.dataSource}
          // renderHeader={() => <span>header</span> }
          renderFooter={() => (<div style={{ padding: 30, textAlign: 'center' }}>
            {this.state.isLoading ? 'Loading...' : 'Loaded'}
          </div>)}
          renderRow={row}
          renderSeparator={separator}
          className="am-list"
          pageSize={4}
          // useBodyScroll
          // onScroll={() => { console.log('scroll'); }}
          scrollRenderAheadDistance={500}
          onEndReached={this.onEndReached}
          onEndReachedThreshold={10}
        />
      </div>
    );
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
};

const mapDispatchToProps = (dispatch) => {
  return {
    showBigPics: bindActionCreators(showBigPics, dispatch),
    axiosGoods: bindActionCreators(axiosGoods, dispatch),
    addCart: bindActionCreators(addShoppingCart, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(GoodsList);