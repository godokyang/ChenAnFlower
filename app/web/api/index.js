import request from 'framework/request'

export const getGoods = (params) => request.get('/v1/goods', params)

export const getShoppingCart = (params) => request.put('/cart/item', params)