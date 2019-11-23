/* eslint-disable func-style */
import React, { Component } from 'react'
import {bindActionCreators} from 'redux'
import { connect } from 'react-redux'
import { Carousel, WingBlank } from 'antd-mobile';
import 'antd-mobile/dist/antd-mobile.css';
import './ridingLantern.css'

class RidingLantern extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      data: ['1', '2', '3'],
      imgHeight: 176
    };
  }

  componentDidMount() {
    // simulate img loading
    setTimeout(() => {
      this.setState({
        data: ['AiyWuByWklrrUDlFignR', 'TekJlZRVCjLFexlOCuWn', 'IJOtIlfsYdTyaDTRVrLI']
      });
    }, 100);
  }
  render() {
    const list = this.props.goodsHandle.bigPics
    return (
      list && list.length > 0 ? <WingBlank className="lantern-banner">
        <Carousel
          autoplay={false}
          infinite
          beforeChange={(from, to) => console.log(`slide from ${from} to ${to}`)}
          afterChange={index => console.log('slide to', index)}
        >
          {list.map((val, index) => (
            <img
              key={`bigPic_${index}`}
              src={val.icon}
              alt=""
              style={{ width: '100%', verticalAlign: 'top' }}
              onLoad={() => {
              // fire window resize event to change height
                window.dispatchEvent(new Event('resize'));
                this.setState({ imgHeight: 'auto' });
              }}
            />
          ))}
        </Carousel>
      </WingBlank> : ''
    );
  }
}

const mapStateToProps = (state) => {
  return state;
};

const mapDispatchToProps = (dispatch) => {
  return {
    // showGoodsPic: bindActionCreators(showGoodsPic, dispatch)
  }
};

export default connect(mapStateToProps, mapDispatchToProps)(RidingLantern);