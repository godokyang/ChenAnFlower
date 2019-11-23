/* eslint-disable func-style */
import React, { Component } from 'react'
import ReactDOM from 'react-dom'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux'
import { ListView, Grid, Carousel, WingBlank } from 'antd-mobile';
import { StickyContainer, Sticky } from 'react-sticky';
import { Icon } from 'antd';
import {showGoodsPic} from '../../page/home/store/actions/goods'
import 'antd-mobile/dist/antd-mobile.css';
import './goodsList.css'

function MyBody(props) {
  return (
    <div className="am-list-body my-body">
      <span style={{ display: 'none' }}>you can custom body wrap element</span>
      {props.children}
    </div>
  );
}

const NUM_ROWS = 20;
let pageIndex = 0;

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
        isLoading: false
      });
    }, 600);
  }

  // If you use redux, the data maybe at props, you need use `componentWillReceiveProps`
  componentWillReceiveProps(nextProps) {
    if (nextProps.dataSource !== this.props.dataSource) {
      this.setState({
        dataSource: this.state.dataSource.cloneWithRows(nextProps.dataSource)
      });
    }
  }

  onEndReached = (event) => {
    // load new data
    // hasMore: from backend data, indicates whether it is the last page, here is false
    if (this.state.isLoading && !this.state.hasMore) {
      return;
    }
    console.log('reach end', event);
    this.setState({ isLoading: true });
    setTimeout(() => {
      this.rData = { ...this.rData, ...genData(++pageIndex) };
      this.setState({
        dataSource: this.state.dataSource.cloneWithRows(this.rData),
        isLoading: false
      });
    }, 1000);
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
    
    const data = this.props.goodsHandle.goodsList
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
          >{obj.des || '晨安&花'}</div>
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
                this.props.showGoodsPic([...images])
              }}
            />
            <div style={{ lineHeight: 1 }}>
              <div style={{ fontWeight: 'bold', fontSize: '14px', padding: '10px', lineHeight: '20px' }}>{obj.goods_name}</div>
              <div style={{ marginBottom: '16px', marginLeft: '7px' }}>¥<span style={{ fontSize: '30px', color: '#FF6E27' }}>{obj.sale_price}</span></div>
            </div>
          </div>
        </div>
      );
    };
    return (
      <ListView
        ref={el => this.lv = el}
        dataSource={this.state.dataSource}
        renderHeader={() => <span>header</span>}
        renderFooter={() => (<div style={{ padding: 30, textAlign: 'center' }}>
          {this.state.isLoading ? 'Loading...' : 'Loaded'}
        </div>)}
        renderRow={row}
        renderSeparator={separator}
        className="am-list"
        pageSize={4}
        useBodyScroll
        onScroll={() => { console.log('scroll'); }}
        scrollRenderAheadDistance={500}
        onEndReached={this.onEndReached}
        onEndReachedThreshold={10}
      />
    );
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
};

const mapDispatchToProps = (dispatch) => {
  return {
    showGoodsPic: bindActionCreators(showGoodsPic, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(GoodsList);