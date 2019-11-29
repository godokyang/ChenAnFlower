import React, { Component } from 'react'
import { Route, Link, Switch } from 'react-router-dom';
import { connect } from 'react-redux';
import Rootlayout from 'component/layout/default'
import Home from '../router/Home'
import Manage from '../router/Manage'
import OrderConfirm from '../router/OrderConfirm'

import './main.css'

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
        <Route path="/web/orderConfirm" component={OrderConfirm} />
      </Switch>
    </Rootlayout>
  }
}

// const mapStateToProps = state => {
//   return state
// }; 

export default Main;