import request from 'framework/request'

export const getGoods = (params) => request.get('/v1/goods', params)

export const getShoppingCart = (params = []) => request.put('/v1/cart/item', params)

export const confirmOrder = (params = []) => request.put('/v1/order', params)

export const submitOrder = (params = {}) => request.post('/v1/order', params)

export const getOrgin = (id ,params) => request.get(`/v1/orgin/${id}`, params)