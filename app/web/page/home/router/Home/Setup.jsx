import React, { Component } from 'react'
import { connect } from 'react-redux'
import {Link, withRouter} from 'react-router-dom'
import * as antd from 'antd'
import * as mAntd from 'antd-mobile'
const AResult = antd.Result
const {Icon, Button, Avatar, message, Modal} = antd
const MResult = mAntd.Result
const {List} = mAntd

import {bindActionCreators} from 'redux'
import webStorage from '@webUtil/storage';
import {getUserInfo} from '@webPage/home/store/actions/user'
import '@web/commoncss/common.css'
import './Setup.css'

const list = [
  {
    tabName: '订单列表',
    desc: '选择查看您的订单列表',
    iconType: 'wallet',
    func: (props) => {
      props.history.push('/web/orderList')
    },
    identityCheck: (identity) => {
      return (identity >= 0 && identity !== 100)
    }
  },
  {
    tabName: '产品编辑',
    desc: '安安要编辑的话点这里哦',
    iconType: 'edit',
    func: (props) => {
      message.info('编辑产品')
    },
    identityCheck: (identity) => {
      return (identity === 100)
    }
  },
  {
    tabName: '订单概览',
    desc: '安安收到的所有的订单都在这里了',
    iconType: 'money-collect',
    func: (props) => {
      props.history.push('/web/rootOrderList')
    },
    identityCheck: (identity) => {
      return (identity === 100)
    }
  },
  {
    tabName: '图表',
    iconType: 'fund',
    desc: '直观的看离富婆还有几步~',
    func: (props) => {
      message.info('图表')
    },
    identityCheck: (identity) => {
      return (identity === 100)
    }
  },
  {
    tabName: '退出登录',
    desc: '清除账号数据',
    iconType: 'delete',
    func: (props) => {
      Modal.confirm({
        title: '确定要清除登录数据吗?',
        content: '',
        okText: '确定',
        okType: 'danger',
        cancelText: '取消',
        onOk() {
          webStorage.removeAll()
          props.checkUserInfo()
          message.info('清除成功', 2)
        },
        onCancel() {
          message.info('已取消', 2)
        }
      });
    },
    identityCheck: (identity) => {
      return identity >= 0
    }
  }
]

class Setup extends Component {

  componentDidMount() {
    this.props.checkUserInfo()
  }

  render() {
    const {checkUser, history} = this.props
    return (
      <div className="root-center">
        {
          (!checkUser || checkUser.status === false) ?
            <AResult
              icon={<Icon type="smile" theme="twoTone" />}
              title="欢迎来到晨安&花"
              subTitle='您还没有登录，快去登录吧!'
              extra={<Button type="primary"><Link to="/web/login">登录</Link></Button>}
            />
            : 
            <div className="login-success">
              <MResult 
                img={<Avatar style={{ backgroundColor: '#7265e6', verticalAlign: 'middle' }} size="large">
                  {checkUser.user_name}
                </Avatar>}
                title="晨安&花欢迎您"
                message="入群请联系微信号: echenan"
              />
              <List className="my-list">
                {
                  list.map((item, index) => {
                    return item.identityCheck(checkUser.identify) ? <List.Item
                      key={`list_${index}`}
                      arrow="horizontal"
                      thumb={<Icon className="icon-fill" type={item.iconType} theme="twoTone"/>}
                      multipleLine
                      onClick={() => {
                        item.func(this.props)
                      }}
                    >
                      {item.tabName} <List.Item.Brief>{item.desc}</List.Item.Brief>
                    </List.Item> : ''
                  })
                }
              </List>
            </div>
            
        }
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state)
}

const mapDispatchToProps = (dispatch) => {
  return {
    checkUserInfo: bindActionCreators(getUserInfo, dispatch)
  }
}

export default connect(mapStateToProps, mapDispatchToProps)(withRouter(Setup))
