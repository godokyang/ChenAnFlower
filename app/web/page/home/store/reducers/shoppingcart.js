import * as actionTypes from '../constants';
import _lodash from 'lodash'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'

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
  const newArr = [...cartArr]
  let hasMerge = false
  const middleArr = newArr.map((item) => {
    let merge = item.sku === obj.sku
    if (merge) {
      hasMerge = true
    }
    return merge ? Object.assign({}, item, obj) : item
  })
  const finalArr = hasMerge ? middleArr : [...newArr, ...[obj]]
  return clearCart(finalArr)
}

const initialState = {
  cartItem: {
    agent_total: 0,
    owner_total: 0,
    sale_total: 0,
    items: []
  },
  cartList: []
}

const shoppingcartCountHandle = (state = initialState.cartList, action) => {
  let newGoodsItem = {}
  let newCart = []
  switch (action.type) {
  case actionTypes.ADD_SHOPPING_CART:
    newGoodsItem = _lodash.find(state, function(o) { return o.sku === action.sku})
    if (newGoodsItem) {
      newGoodsItem.quantity ++
    } else {
      newGoodsItem = {sku: action.sku, quantity: 1}
    }
    newCart = mergeSkuObjToCart(state, newGoodsItem)
    webStorage.set(storageKey.shoppingCart, newCart)
    return newCart
  case actionTypes.GET_SHOPPING_CART:
    newCart = webStorage.get(storageKey.shoppingCart, [])
    return newCart
  case actionTypes.REDUCE_SHOPPING_CART:
    newGoodsItem = _lodash.find(state, function(o) { return o.sku === action.sku})
    newGoodsItem.quantity --
    newCart = mergeSkuObjToCart(state, newGoodsItem)
    webStorage.set(storageKey.shoppingCart, newCart)
    return newCart
  case actionTypes.SET_SHOPPING_CART:
    newGoodsItem = action.data
    newCart = mergeSkuObjToCart(state, newGoodsItem)
    webStorage.set(storageKey.shoppingCart, newCart)
    return newCart
  case actionTypes.REMOVE_SHOPPING_CART:
    newGoodsItem = _lodash.find(state, function(o) { return o.sku === action.sku})
    newGoodsItem.quantity = 0
    newCart = mergeSkuObjToCart(state, newGoodsItem)
    webStorage.set(storageKey.shoppingCart, newCart)
    return newCart
  case actionTypes.REMOVE_ALL_SHOPPING_CART:
    webStorage.set(storageKey.shoppingCart, [])
    return []
  default:
    return state
  }
}

const getShoppingCartItem = (state = initialState.cartItem, action) => {
  if (action.type === actionTypes.GET_SHOPPING_CART_ITEM) {
    return action.data
  }
  return state
}

export {shoppingcartCountHandle, getShoppingCartItem}