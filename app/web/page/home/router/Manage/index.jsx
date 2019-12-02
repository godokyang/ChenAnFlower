import React, { Component } from 'react'
import { Route, Link, Switch } from 'react-router-dom';
import { connect } from 'react-redux';

class Manage extends Component {
  constructor(props) {
    super(props);
  }

  handleClick(current) {
    this.setState({
      current
    });
  }

  render() {
    return <div>
      <Link to="/web/login">登录</Link>
    </div>
  }
}

const mapStateToProps = (state) => {
  return state;
};

export default connect(mapStateToProps)(Manage);