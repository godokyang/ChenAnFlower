import _lodash from 'lodash'
import * as actionTypes from '../constants'
import * as api from '@webApi'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'

const axiosShoppingcart = () => {
  return async dispatch => {
    try {
      let res = await api.getShoppingCart(webStorage.get(storageKey.shoppingCart, []))
      let cartInfo = _lodash.get(res, 'data.data.pro_infos', {})
      dispatch(getShoppingCartItem(cartInfo))
    } catch (error) {
      dispatch(getShoppingCartItem([]))
      console.warn(`AXIOSGOODS FROM GOODS ACTION ERROR: ${error}`);
    }
  }
}

const getShoppingCart = () => {
  return {
    type: actionTypes.GET_SHOPPING_CART
  }
}

const addShoppingCart = (sku) => {
  return {
    type: actionTypes.ADD_SHOPPING_CART,
    sku
  }
}

const setShoppingCart = (data) => {
  // {sku: xxx, quantity:xxx}
  return {
    type: actionTypes.SET_SHOPPING_CART,
    data
  }
}

const removeShoppingCart = (sku) => {
  return {
    type: actionTypes.REMOVE_SHOPPING_CART,
    sku
  }
}

const reduceShoppingCart = (sku) => {
  return {
    type: actionTypes.REDUCE_SHOPPING_CART,
    sku
  }
}

const getShoppingCartItem = (data) => {
  return {
    type: actionTypes.GET_SHOPPING_CART_ITEM,
    data
  }
}

const removeAllShoppingCart = () => {
  return {
    type: actionTypes.REMOVE_ALL_SHOPPING_CART
  }
}

export { axiosShoppingcart, getShoppingCart, addShoppingCart, removeShoppingCart, setShoppingCart, reduceShoppingCart, removeAllShoppingCart }