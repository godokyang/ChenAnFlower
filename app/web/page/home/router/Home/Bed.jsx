import React, { Component } from 'react'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux';
import request from 'framework/request'
import {loadGoodsAsync} from '../../store/actions/goods'

class Bed extends Component {
  constructor (props) {
    super(props)
    console.log('====================================');
    console.log(this.props);
    console.log('====================================');
    if (!this.props.goods) {
      this.props.loadGoodsAsync();
    }
  }
  
  
  render() {
    const list = this.props.goods.value;
    return (
      <div>
        {list.toString()}
      </div>
    )
  }
}

const mapStateToProps = (state) => {
  return state;
};
const mapDispatchToProps = (dispatch) => {
  return {
    loadGoodsAsync: bindActionCreators(loadGoodsAsync, dispatch)
  }
};
export default connect(mapStateToProps,mapDispatchToProps)(Bed);
