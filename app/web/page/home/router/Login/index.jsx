import React, {Component} from 'react'
import {Form, Icon, Input, Button, Spin, Tooltip, message} from 'antd'
import _lodash from 'lodash'
import Header from '@webComp/common/header'
import * as api from '@webApi'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'
import { connect } from 'react-redux';
import {bindActionCreators} from 'redux'
import {getUserInfo} from '@webPage/home/store/actions/user'
import './index.css'
import '@web/commoncss/common.css'
message.config({
  top: '100px'
})

class NormalLoginForm extends Component {
  state = {
    loading: false
  }

  handleSubmit = e => {
    e.preventDefault();
    this.props.form.validateFields(async (err, values) => {
      this.setState({
        loading: true
      })
      if (!err) {
        console.log('Received values of form: ', values);
        try {
          let result = await api.createAndRegistUser(values)
          webStorage.set(storageKey.AT, _lodash.get(result, 'data.data.access_token', ''))
          await this.props.checkUserInfo()
          message.info('登录成功', 2)
          setTimeout(() => {
            this.props.history.goBack()
          }, 2000);
        } catch (error) {
          message.info('用户名或密码错误', 2)
        }
        
        this.setState({
          loading: false
        })
      }
      this.setState({
        loading: false
      })
    });
  };

  render() {
    const { getFieldDecorator } = this.props.form;
    const {history} = this.props
    return (
      <div className="root-center">
        {
          this.state.loading ? <Spin style={{zIndex: 9999}} className='loading' /> : ''
        }
        <Header subTitle='登录注册' history={history} />
        <Form onSubmit={this.handleSubmit} className="login-form">
          <Form.Item>
            {getFieldDecorator('user_name', {
              rules: [{ required: true, message: '请输入用户名!' }]
            })(
              <Input
                prefix={<Icon type="user" style={{ color: 'rgba(0,0,0,.25)' }} />}
                placeholder="用户名"
              />,
            )}
          </Form.Item>
          <Form.Item>
            {getFieldDecorator('password', {
              rules: [{ required: true, message: '请输入密码!' }]
            })(
              <Input
                prefix={<Icon type="lock" style={{ color: 'rgba(0,0,0,.25)' }} />}
                type="password"
                placeholder="密码"
              />,
            )}
          </Form.Item>
          <Form.Item>
            <div style={{width: '100%', display: 'flex', flexDirection: 'row', justifyContent: 'space-between'}}>
              <Tooltip title="请联系管理员">
                <a>忘记密码</a>
              </Tooltip>
              <Tooltip title="输入密码即可自动注册">
                <a>注册</a>
              </Tooltip>
            </div>
            <Button type="primary" htmlType="submit" className="login-form-button">
            登 录
            </Button>
          </Form.Item>
        </Form>
      </div>
    );
  }
}

const Login = Form.create({ name: 'normal_login' })(NormalLoginForm);

const mapStateToProps = (state) => {
  return Object.assign({}, state)
};

const mapDispatchToProps = (dispatch) => {
  return {
    checkUserInfo: bindActionCreators(getUserInfo, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(Login);
// export default Login