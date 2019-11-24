import _lodash from 'lodash'
import * as actionTypes from '../constants'
import * as api from '@webApi'


const axiosGoods = (params) => {
  return async dispatch => {
    try {
      let res = await api.getGoods(params)
      let newGoodsList = _lodash.get(res, 'data.data.goods', [])
      dispatch(loadGoods(newGoodsList))
    } catch (error) {
      console.log(`AXIOSGOODS FROM GOODS ACTION ERROR: ${error}`);
    }
  }
}

const loadGoods = data => {
  return {
    type: actionTypes.LOAD_GOODS,
    data
  }
}

const showBigPics = (data) => {
  return {
    type: actionTypes.SHOW_BIG_PICS,
    data
  }
}

const hideBigPics = () => {
  return {
    type: actionTypes.HIDE_BIG_PICS
  }
}

export {loadGoods, showBigPics, hideBigPics, axiosGoods}