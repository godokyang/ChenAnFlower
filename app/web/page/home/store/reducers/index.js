import { combineReducers } from 'redux'
import {goodsHandle} from './goods'

// egg context 中携带的state 需要在combineReducers入参中定义才能保留
const locale = (state) => {return Object.assign({}, {value:state})}
const origin = (state) => {return Object.assign({}, {value:state})}
const url = (state) => {return Object.assign({}, {value:state})}
const side = (state) => { return Object.assign({}, {value:state})}
const goods = (state) => { return Object.assign({}, {value:state})}

export default combineReducers({
  goodsHandle,
  locale,
  origin,
  url,
  side,
  goods
})