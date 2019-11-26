'use strict';
import axios from 'axios';
// axios.defaults.baseURL = 'http://127.0.0.1:7001';
axios.defaults.timeout = 15000;
axios.defaults.xsrfHeaderName = 'x-csrf-token';
axios.defaults.xsrfCookieName = 'csrfToken';
const SERVICE_DNS = 'http://localhost:7001'

const AT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmeSI6MCwidXNlcl9uYW1lIjoidGVzdCIsIm5pY2tfbmFtZSI6bnVsbCwicGhvbmVfbnVtYmVyIjpudWxsLCJlbWFpbCI6bnVsbCwiaGVhZF9pbWFnZSI6bnVsbCwiY3JlYXRlX3RpbWUiOjAsInVuaW9uX2lkIjpudWxsLCJjdXN0b21lcl9pZCI6MTAwMDAwMDAwMDIsInN0YXR1cyI6MTAsImlhdCI6MTU3NDc3MzA3NywiZXhwIjoxNTc1MDMyMjc3fQ.Z4KhQR6M1AQLl6wwHPq8dvtGBYdFE9zLa-Z6uux012U'

export default {
  post(url, params ={}, state = {}) {
    params.headers = {};
    if (EASY_ENV_IS_NODE) {
      params.headers['x-csrf-token'] = !!state.csrf;
      params.headers.Cookie = `csrfToken=${state.csrf}`;
    }
    if (EASY_ENV_IS_DEV) {
      params.headers.authorization = AT
    }
    return axios.post(`${state.origin || SERVICE_DNS}${url}`, params);
  },
  get(url, params ={}, state = {}) {
    params.headers = {}
    if (EASY_ENV_IS_NODE ) {
      params.headers['x-csrf-token'] = state.csrf || false;
      params.headers.Cookie = `csrfToken=${state.csrf}`;
    }
    
    if (EASY_ENV_IS_DEV) {
      params.headers.authorization = AT
    }
    return axios.get(`${state.origin || SERVICE_DNS}${url}`, params);
  },
  put(url, params ={}, state = {}) {
    params.headers = {};
    if (EASY_ENV_IS_NODE) {
      params.headers['x-csrf-token'] = !!state.csrf;
      params.headers.Cookie = `csrfToken=${state.csrf}`;
    }
    if (EASY_ENV_IS_DEV) {
      params.headers.authorization = AT
    }
    return axios.put(`${state.origin || SERVICE_DNS}${url}`, params);
  },
  delete(url, params ={}, state = {}) {
    params.headers = {};
    if (EASY_ENV_IS_NODE) {
      params.headers['x-csrf-token'] = !!state.csrf;
      params.headers.Cookie = `csrfToken=${state.csrf}`;
    }
    if (EASY_ENV_IS_DEV) {
      params.headers.authorization = AT
    }
    return axios.delete(`${state.origin || SERVICE_DNS}${url}`, params);
  }
};