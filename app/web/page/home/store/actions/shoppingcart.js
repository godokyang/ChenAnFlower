import _lodash from 'lodash'
import * as actionTypes from '../constants'
import * as api from '@webApi'


const axiosShoppingcart = (params) => {
  return async dispatch => {
    try {
      let res = await api.getShoppingCart(params)
      let newShoppingCartList = _lodash.get(res, 'data.data.goods', [])
      dispatch(getShoppingCartItem(newShoppingCartList))
    } catch (error) {
      console.warn(`AXIOSGOODS FROM GOODS ACTION ERROR: ${error}`);
    }
  }
}

const getShoppingCart = (data) => {
  return {
    type: actionTypes.GET_SHOPPING_CART,
    data
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

export { axiosShoppingcart, getShoppingCart, addShoppingCart, removeShoppingCart, setShoppingCart, reduceShoppingCart }