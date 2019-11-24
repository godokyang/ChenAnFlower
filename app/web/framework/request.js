'use strict';
import axios from 'axios';
// axios.defaults.baseURL = 'http://127.0.0.1:7001';
axios.defaults.timeout = 15000;
axios.defaults.xsrfHeaderName = 'x-csrf-token';
axios.defaults.xsrfCookieName = 'csrfToken';
const SERVICE_DNS = 'http://localhost:7001'

const AT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmeSI6MTAwLCJ1c2VyX25hbWUiOiJyb290Iiwibmlja19uYW1lIjpudWxsLCJwaG9uZV9udW1iZXIiOm51bGwsImVtYWlsIjpudWxsLCJoZWFkX2ltYWdlIjpudWxsLCJjcmVhdGVfdGltZSI6MCwidW5pb25faWQiOm51bGwsImN1c3RvbWVyX2lkIjoxMDAwMDAwMDAwMSwic3RhdHVzIjoxMCwiaWF0IjoxNTc0MzkyMjEyLCJleHAiOjE1NzQ2NTE0MTJ9.nhgByLo-ZN6Ti7hV6R5cgWO-IdCtRyQrIAHMdZ6J1eE'

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