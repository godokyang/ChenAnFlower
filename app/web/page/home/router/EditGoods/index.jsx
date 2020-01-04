import React, { Component } from 'react'
import { connect } from 'react-redux'
import {Link} from 'react-router-dom'
import { Avatar, message, List, Tag, Descriptions, Select, Icon, Button, Input } from 'antd'
import _lodash from 'lodash'
import * as api from '@webApi'
import Header from '@webComp/common/header'
import { relative } from 'path'
const { TextArea } = Input

class ListItem extends Component {
  constructor(props) {
    super(props)
  }

  componentDidMount() {
    this.setState({
      data: this.props.data
    })
  }
  
  state = {
    isError: false,
    data: {}
  }

  inputChange(e) {
    let obj = this.state.data
    obj[e.target.id] = e.target.value
    this.setState({
      data: obj
    })
  }

  render() {
    const {data} = this.props
    return <div style={{width: '100%'}}>
      {/* <Descriptions bordered>
        <Descriptions.Item label="产品描述">
          <div style={{width: '40%'}}>
            <TextArea
              id="goods_name"
              autoSize={true}
              value={data.goods_name}
              maxLength={500}
              onChange={this.inputChange.bind(this)}
            />
          </div>
        </Descriptions.Item>
        <Descriptions.Item label="图片">{data.images}</Descriptions.Item>
        <Descriptions.Item label="视频">{data.video}</Descriptions.Item>
        <Descriptions.Item label="显示等级">{data.show_level}</Descriptions.Item>
        <Descriptions.Item label="卖价">{data.sale_price}</Descriptions.Item>
        <Descriptions.Item label="操作">
          <Button type="primary">提 交</Button>
          <Button type="danger">删 除</Button>
        </Descriptions.Item>
      </Descriptions> */}
    </div>
  }
}

export class EditGoods extends Component {

  state = {
    loading: false,
    hasMore: true,
    list: [],
    order_status_mapping: {},
    payment_mapping: {},
    user_info: {}
  }

  componentWillMount() {
    this.getGoods().then(list => {
      this.setState({list: list})
    })
  }

  async getGoods(params = {}) {
    try {
      let res = await api.getGoods(params)
      let goodsList = _lodash.get(res, 'data.data.goods', [])
      return goodsList
    } catch (error) {
      return []
    }
  }

  handleInfiniteOnLoad = () => {
    let { list } = this.state;
    this.setState({
      loading: true
    });
    // if (list.length > 14) {
    //   message.warning('Infinite List loaded all');
    //   this.setState({
    //     hasMore: false,
    //     loading: false
    //   });
    //   return;
    // }
    this.getGoods({last_id: list[list.length-1].sku}).then(res => {
      list = list.concat(res);
      this.setState({list: list, loading: false});
      if (res.list.length < 10) {
        this.setState({
          hasMore: false,
          loading: false
        });
        message.warning('没有更多了');
      }
    });
  };

  render() {
    const { history } = this.props
    const { list } = this.state
    const loadMore =
      !this.state.loading && this.state.hasMore ? (
        <div
          style={{
            textAlign: 'center',
            padding: '12px'
          }}
        >
          <Button onClick={this.handleInfiniteOnLoad}>加载更多</Button>
        </div>
      ) : null;
    return (
      <div>
        <Header subTitle="订单列表" history={history} />
        {/* <InfiniteScroll
          style={{marginTop: '65px'}}
          pageStart={0}
          useWindow={false}
        > */}
        <List
          // header={<div>Header</div>}
          // footer={<div>Footer</div>}
          style={{marginTop: '65px'}}
          loadMore={loadMore}
          hasMore={!this.state.loading && this.state.hasMore}
          bordered
          dataSource={list}
          renderItem={item => (
            <List.Item>
              <ListItem data={item} />
              {/* <div>{JSON.stringify(item)}</div>  */}
            </List.Item>
          )}
        />
        {/* </InfiniteScroll> */}
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return {}
}

const mapDispatchToProps = {
  // return {}
}

export default connect(mapStateToProps, mapDispatchToProps)(EditGoods)

