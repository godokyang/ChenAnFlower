'use strict';
import axios from 'axios';
// axios.defaults.baseURL = 'http://127.0.0.1:7001';
axios.defaults.timeout = 15000;
axios.defaults.xsrfHeaderName = 'x-csrf-token';
axios.defaults.xsrfCookieName = 'csrfToken';

const AT = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmeSI6MTAwLCJ1c2VyX25hbWUiOiJyb290Iiwibmlja19uYW1lIjpudWxsLCJwaG9uZV9udW1iZXIiOm51bGwsImVtYWlsIjpudWxsLCJoZWFkX2ltYWdlIjpudWxsLCJjcmVhdGVfdGltZSI6MCwidW5pb25faWQiOm51bGwsImN1c3RvbWVyX2lkIjoxMDAwMDAwMDAwMSwic3RhdHVzIjoxMCwiaWF0IjoxNTc0MzkyMjEyLCJleHAiOjE1NzQ2NTE0MTJ9.nhgByLo-ZN6Ti7hV6R5cgWO-IdCtRyQrIAHMdZ6J1eE'

export default {
  post(url, json, state = {}) {
    const headers = {};
    if (EASY_ENV_IS_NODE) {
      headers['x-csrf-token'] = state.csrf;
      headers.Cookie = `csrfToken=${state.csrf}`;
      headers.authorization = AT
    }
    return axios.post(`${state.origin}${url}`, json, { headers });
  },
  get(url, state = {}) {
    const headers = {};
    if (EASY_ENV_IS_NODE) {
      headers.authorization = AT
    }
    return axios.get(`${state.origin}${url}`, { headers });
  },
  put(url, json, state = {}) {
    const headers = {};
    if (EASY_ENV_IS_NODE) {
      headers['x-csrf-token'] = state.csrf;
      headers.Cookie = `csrfToken=${state.csrf}`;
      headers.authorization = AT
    }
    return axios.put(`${state.origin}${url}`, json, { headers });
  },
  delete(url, json, state = {}) {
    const headers = {};
    if (EASY_ENV_IS_NODE) {
      headers['x-csrf-token'] = state.csrf;
      headers.Cookie = `csrfToken=${state.csrf}`;
      headers.authorization = AT
    }
    return axios.delete(`${state.origin}${url}`, json, { headers });
  }
};