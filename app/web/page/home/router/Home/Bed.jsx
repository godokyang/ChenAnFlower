import React, { Component } from 'react'
import { connect } from 'react-redux'
import {bindActionCreators} from 'redux';
import {loadGoods} from '../../store/actions/goods'
import {asyncAPI} from '../../store/actions/axiosData'
import GoodsList from '../../../../component/home/goodsList'
import RidingLantern from '../../../../component/home/ridingLantern'

class Bed extends Component {
  constructor (props) {
    super(props)
    
  }

  componentDidMount() {
    // if (!this.props.goods.value) {
    //   this.props.asyncAPI('/api/goods','get',loadGoods);
    // }
  }
  
  
  render() {

    return (
      <div>
        <GoodsList style={{zIndex: 1}} />
        <RidingLantern style={{zIndex: 10}} />
      </div>
    )
  }
}

export default Bed;
