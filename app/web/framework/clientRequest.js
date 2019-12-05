'use strict';
import axios from 'axios';
import {BrowserRouter} from 'react-router-dom'
import webStorage from '@webUtil/storage'
import {storageKey} from '@webConfig'
import createRouter from '@webPage/home/router'

const instence = axios.create({
  headers: {
    'x-csrf-token': false,
    'content-type': 'application/json;charset=UTF-8'
  }
})

instence.interceptors.request.use(
  config => {
    config.headers.authorization = webStorage.get(storageKey.AT) || ''
    return config
  },
  err => {
    return Promise.reject(err)
  }
)

instence.interceptors.response.use(
  response => {
    return response
  },
  error => {
    if (error.response.status === 401) {
      // 401的控制放到router main.jsx中
    }
    return Promise.reject(error.response.status)
  }
)
const SERVICE_DNS = 'http://localhost:7001'

export default {
  post(url, params ={}, state = {}) {
    return instence.post(`${state.origin || SERVICE_DNS}${url}`, params);
  },
  get(url, params ={}, state = {}) {
    return instence.get(`${state.origin || SERVICE_DNS}${url}`, {params});
  },
  put(url, params ={}, state = {}) {
    return instence.put(`${state.origin || SERVICE_DNS}${url}`, params)
  },
  delete(url, params ={}, state = {}) {
    return instence.delete(`${state.origin || SERVICE_DNS}${url}`, params);
  }
};