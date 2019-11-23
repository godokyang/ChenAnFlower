import * as actionTypes from '../constants'
import { createAction } from 'redux-promise'

const loadGoods = data => {
  return {
    type: actionTypes.LOAD_GOODS,
    data
  }
}

const showGoodsPic = (data) => {
  return {
    type: actionTypes.SHOW_GOODS_PIC,
    data
  }
}

export {loadGoods, showGoodsPic}