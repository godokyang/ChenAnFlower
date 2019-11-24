import React, { Component } from 'react'
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
      <div style={{height:'100%', width: '100%'}}>
        <GoodsList style={{zIndex: 1}} />
        <RidingLantern />
      </div>
    )
  }
}

export default Bed;
