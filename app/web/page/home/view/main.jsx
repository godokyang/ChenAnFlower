import React, { Component } from 'react'
import { Route, Link, Switch, Redirect,withRouter } from 'react-router-dom';
import * as api from '@webApi'
import _lodash from 'lodash'
import Rootlayout from 'component/layout/default'
import Home from '../router/Home'
import Manage from '../router/Manage'
import OrderConfirm from '../router/OrderConfirm'
import OrderList from '../router/OrderList'
import RootOrderList from '../router/RootOrderList'
import OrderDetail from '../router/OrderDetail'
import Login from '../router/Login'
import EditGoods from '../router/EditGoods';

import './main.css'


const LoginRedirect = (props) => {
  return <Redirect to='/web/login' />
}

class AuthRoute extends Component {
  constructor(props) {
    super(props)
  }

  state = {
    loaded: false,
    loginStatus: true
  }

  componentWillUnmount() {
    this._isMounted = false;
  }

  componentWillMount() {
    this._isMounted = true;
    // this.props.checkUserInfo()
    api.getUserInfo().then(res => {
      const status = _lodash.get(res, 'data.data.user_info.status', false)
      if(this._isMounted){
        this.setState({
          loginStatus: status,
          loaded: true
        })
      }
    })
  }

  render() {
    const {Component, ...rest} = this.props
    const { loginStatus, loaded } = this.state
    if (!loaded) return null
    return <Route
      {...rest}
      render={props => {
        return !loginStatus ? (<LoginRedirect />) : (<Component {...props} />)
      }}
    />

  }
}

const PriviteRoute = withRouter(AuthRoute);

class Main extends Component {
  constructor(props) {
    super(props);
    this.state = { current: props.url || '/' };
  }

  handleClick(current) {
    this.setState({
      current
    });
  }

  render() {
    return <Rootlayout {...this.props}>
      <Switch>
        <Route path="/web/home" component={Home} />
        <Route path="/web/client" component={Home} />
        <Route path="/web/manage" component={Manage} />
        <PriviteRoute path='/web/orderConfirm' Component={OrderConfirm} />
        <PriviteRoute path="/web/orderList" component={OrderList} />
        <PriviteRoute path="/web/orderDetail" component={OrderDetail} />
        <PriviteRoute path="/web/rootOrderList" component={RootOrderList} />
        <PriviteRoute path="/web/editGoods" component={EditGoods} />
        <Route path="/web/login" component={Login} />
      </Switch>
    </Rootlayout>
  }
}

// const mapStateToProps = state => {
//   return state
// }; 


// const mapStateToProps = (state) => {
//   return Object.assign({}, state)
// };

// const mapDispatchToProps = (dispatch) => {
//   return {
//     checkUserInfo: bindActionCreators(getUserInfo, dispatch)
//   }
// };

// export default connect(mapStateToProps, mapDispatchToProps)(Main);
export default Main;