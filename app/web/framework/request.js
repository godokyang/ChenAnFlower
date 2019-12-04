'use strict';
import axios from 'axios';
// axios.defaults.baseURL = 'http://127.0.0.1:7001';
axios.defaults.timeout = 15000;
axios.defaults.xsrfHeaderName = 'x-csrf-token';
axios.defaults.xsrfCookieName = 'csrfToken';
const SERVICE_DNS = 'http://localhost:7001'

export default {
  post(url, params ={}, state = {}) {
    const headers = {};
    headers['x-csrf-token'] = !!state.csrf || false;
    return axios.post(`${state.origin || SERVICE_DNS}${url}`, params, {headers});
  },
  get(url, params ={}, state = {}) {
    params.headers = {}
    params.headers['x-csrf-token'] = state.csrf || false;
    return axios.get(`${state.origin || SERVICE_DNS}${url}`, params);
  },
  put(url, params ={}, state = {}) {
    const headers = {};
    headers['x-csrf-token'] = !!state.csrf || false;
    return axios.put(`${state.origin || SERVICE_DNS}${url}`, params, {headers});
  },
  delete(url, params ={}, state = {}) {
    const headers = {};
    headers['x-csrf-token'] = !!state.csrf || false;
    return axios.delete(`${state.origin || SERVICE_DNS}${url}`, params, {headers});
  }
};