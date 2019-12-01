import _lodash from 'lodash'
import * as actionTypes from '../constants'
import * as api from '@webApi'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'
import {depTypeOf} from '@webUtil'
const orginArr = ['province', 'county', 'city']
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

const axiosSetOrgin = (id, type = 2) => {
  return async dispatch => {
    try {
      let res = await api.getOrgin(id, {params: {type}})
      let orgin = _lodash.get(res, 'data.data.orgin', null)
      dispatch(setOrgin(orgin))
    } catch (error) {
      console.warn(`AXIOSSETORGIN ACTION ERROR: ${error}`);
    }
  }
}

const setOrgin = (data) => {
  let newData = {}
  if (depTypeOf(data) === 'array') {
    for (let index = 0; index < data.length; index++) {
      const key = orginArr[index]
      const element = data[index];
      newData[key] = element
    }
  } else {
    newData = data
  }
  return {
    type: actionTypes.SET_ORGIN,
    data: newData
  }
}

const getConfirmOrder = (data) => {
  return {
    type: actionTypes.CONFIRM_ORDER,
    data
  }
}

const submitPartOrder = (data) => {
  return {
    type: actionTypes.SUBMIT_PART_ORDER,
    data
  }
}

export { axiosConfirm, axiosSetOrgin, setOrgin, submitPartOrder }