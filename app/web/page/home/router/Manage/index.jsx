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
      管理
    </div>
  }
}

const mapStateToProps = (state) => {
  return state;
};

export default connect(mapStateToProps)(Manage);