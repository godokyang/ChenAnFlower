import request from 'framework/request'

export const asyncAPI = (url,method, reducer) => {
  return dispatch => {
    return request[method](url)
      .then(res => res.json())
      .then(json => dispatch(reducer(json)))
  }
}