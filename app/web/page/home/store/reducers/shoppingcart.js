import * as actionTypes from '../constants';
import _lodash from 'lodash'
import { log } from 'util';

const clearCart = (cartArr) => {
  for (let index = 0,len = cartArr.length; index < len; index++) {
    const element = cartArr[index];
    if (element.quantity < 1) {
      cartArr.splice(index, 1);
      len--
      index--
    }
  }
  return cartArr
}

const mergeSkuObjToCart = (cartArr, obj) => {
  const newArr = [...[], ...cartArr]
  const finalArr = newArr.map((item) => {
    let merge = false
    for (const key in item) {
      if (item.hasOwnProperty(key)) {
        if (obj[key]) {
          merge = true
          break
        }
      }
    }
    return merge ? Object.assign(item, obj) : item
  })
  return clearCart(finalArr)
}

const initialState = {
  cartList: [],
  cartItemList: []
}

const shoppingcartCountHandle = (state = initialState.cartList, action) => {
  let newGoodsItem = {}
  switch (action.type) {
  case actionTypes.ADD_SHOPPING_CART:
    if (state.indexOf(action.sku) === -1) {
      return [...state, ...[{
        sku: action.sku,
        quantity: 1
      }]]
    }
    newGoodsItem = _lodash.find(state, function(o) { return o.sku === action.sku})
    newGoodsItem.quantity ++
    return mergeSkuObjToCart(state, newGoodsItem)
  case actionTypes.GET_SHOPPING_CART:
    return [...action.data]
  case actionTypes.REDUCE_SHOPPING_CART:
    newGoodsItem = _lodash.find(state, function(o) { return o.sku === action.sku})
    newGoodsItem.quantity --
    return mergeSkuObjToCart(state, newGoodsItem)
  case actionTypes.SET_SHOPPING_CART:
    return mergeSkuObjToCart(state, action.data)
  case actionTypes.REMOVE_SHOPPING_CART:
    newGoodsItem = _lodash.find(state, function(o) { return o.sku === action.sku})
    newGoodsItem.quantity = 0
    return mergeSkuObjToCart(state, newGoodsItem)
  default:
    return state
  }
}

const getShoppingCartItem = (state = initialState.cartItemList, action) => {
  if (action.GET_SHOPPING_CART_ITEM) {
    return action.data
  }
  return state
}

export {shoppingcartCountHandle, getShoppingCartItem}