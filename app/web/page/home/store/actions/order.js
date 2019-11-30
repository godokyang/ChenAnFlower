import _lodash from 'lodash'
import * as actionTypes from '../constants'
import * as api from '@webApi'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'

const axiosConfirm = () => {
  return async dispatch => {
    try {
      let res = await api.confirmOrder(webStorage.get(storageKey.shoppingCart, []))
      let orderInfo = _lodash.get(res, 'data.data.order_info', {})
      dispatch(axiosSetOrgin(orderInfo.address.ADD_ID))
      dispatch(getConfirmOrder(orderInfo))
    } catch (error) {
      console.warn(`AXIOSCONFIRM ACTION ERROR: ${error}`);
    }
  }
}

const axiosSetOrgin = (id, type = 2, indexArr = []) => {
  return async dispatch => {
    try {
      let res = await api.getOrgin(id, {params: {type}})
      let orgin = _lodash.get(res, 'data.data.orgin', null)
      if (type === 2) {
        dispatch(setOrgin(orgin))
      } else {
        dispatch(setSubOrgin({orgin, indexArr}))
      }
    } catch (error) {
      console.warn(`AXIOSSETORGIN ACTION ERROR: ${error}`);
    }
  }
}

const setOrgin = (data) => {
  return {
    type: actionTypes.SET_ORGIN,
    data
  }
}

const setSubOrgin = (data) => {
  data.orgin = data.orgin.map((item) => {
    return Object.assign(item, {isLeaf: false})
  })
  return {
    type: actionTypes.SET_SUB_ORGIN,
    data
  }
}

const getConfirmOrder = (data) => {
  return {
    type: actionTypes.CONFIRM_ORDER,
    data
  }
}

export { axiosConfirm, axiosSetOrgin, setOrgin }