import request from 'framework/clientRequest'

export const getUserInfo = (params) => request.get('/v1/user', params)

export const getGoods = (params) => request.get('/v1/goods', params)

export const getShoppingCart = (params = []) => request.put('/v1/cart/item', params)

export const confirmOrder = (params = []) => request.put('/v1/order', params)

export const submitOrder = (params = {}) => request.post('/v1/order', params)

export const getOrgin = (id ,params) => request.get(`/v1/orgin/${id}`, params)

export const getOrderList = (params) => request.get('/v1/order/list', params)

export const getOrderListGoods = (order_id, params) => request.get(`/v1/order/${order_id}/goods`, params)

export const getAddressById = (address_id, params) => request.get(`/v1/address/${address_id}`, params)

export const createAndRegistUser = (params) => request.post('/v1/user', params)