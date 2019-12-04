import request from 'framework/clientRequest'
import _lodash from 'lodash'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'

export const getUserInfo = (params) => {
  return new Promise(async (resolve, reject) => {
    let res = webStorage.get(storageKey.userInfo) || await request.get('/v1/user', params)
    const status = _lodash.get(res, 'data.data.user_info.status', false)
    if (status) {
      webStorage.set(storageKey.userInfo, res)
    } else {
      webStorage.set(storageKey.userInfo, null)
    }
    resolve(res)
  })
}

export const getGoods = (params) => request.get('/v1/goods', params)

export const getShoppingCart = (params = []) => request.put('/v1/cart/item', params)

export const confirmOrder = (params = []) => request.put('/v1/order', params)

export const submitOrder = (params = {}) => request.post('/v1/order', params)

export const getOrgin = (id ,params) => request.get(`/v1/orgin/${id}`, params)

export const getOrderList = (params) => request.get('/v1/order/list', params)

export const getOrderListGoods = (order_id, params) => request.get(`/v1/order/${order_id}/goods`, params)

export const getAddressById = (address_id, params) => request.get(`/v1/address/${address_id}`, params)

export const createAndRegistUser = (params) => request.post('/v1/user', params)

export const updateOrderInfo = (id, params) => request.put(`/v1/order/${id}`, params)