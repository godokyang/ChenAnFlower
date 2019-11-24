/* eslint-disable func-style */
import React, { Component } from 'react'
import {bindActionCreators} from 'redux'
import { connect } from 'react-redux'
import {Button} from 'antd'
import { Carousel, WingBlank } from 'antd-mobile';
import 'antd-mobile/dist/antd-mobile.css';
import './ridingLantern.css'

import {hideBigPics} from '@webPage/home/store/actions/goods'

class RidingLantern extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      imgHeight: 176
    };
  }

  componentDidMount() {
  }
  
  render() {
    const {bigPics, bigPicIndex} = this.props.goodsHandle
    return (
      bigPics && bigPics.length > 0 ?
        <div className="lantern-banner">
          <Button 
            className="lantern-banner-cross" 
            shape="circle" 
            ghost 
            size="small" 
            icon="close" 
            onClick={() => {
              this.props.hideBigPics()
            }}
          />
          <Carousel
            className="space-carousel"
            selectedIndex={bigPicIndex}
            cellSpacing={20}
            autoplay={false}
            infinite
            slideWidth={0.9}
          >
            {bigPics.map((val, index) => (
              <img
                key={`bigPic_${index}`}
                src={val.icon}
                alt=""
                style={{ minWidth: '100%', maxHeight: '70vh', verticalAlign: 'center' }}
                onLoad={() => {
                  // fire window resize event to change height
                  window.dispatchEvent(new Event('resize'));
                  this.setState({ imgHeight: 'auto' });
                }}
              />
            ))}
          </Carousel>
        </div>
        : ''
    );
  }
}

const mapStateToProps = (state) => {
  return Object.assign({}, state);
};

const mapDispatchToProps = (dispatch) => {
  return {
    hideBigPics: bindActionCreators(hideBigPics, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(RidingLantern);