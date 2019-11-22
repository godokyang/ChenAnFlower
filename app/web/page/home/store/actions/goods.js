import * as actionTypes from '../constants'
import { createAction } from 'redux-promise'
import request from 'framework/request'

const loadGoods = data => {
  return {
    type: actionTypes.LOAD_GOODS,
    data
  }
}

const loadGoodsAsync = context => createAction(actionTypes.LOAD_GOODS, request.get('/v1/goods', context.state))

export {loadGoods, loadGoodsAsync}