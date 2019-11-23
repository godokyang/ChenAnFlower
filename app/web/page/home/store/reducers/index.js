import { combineReducers } from 'redux'
import {goodsHandle} from './goods'

// egg context 中携带的state 需要在combineReducers入参中定义才能保留
const locale = (state = 'CN') => {return state}
const origin = (state = 'localhost:7001') => {return state}
const url = (state = '/web/home') => {return state}
const side = (state = 'server') => {return state}

export default combineReducers({
  goodsHandle,
  locale,
  origin,
  url,
  side
})