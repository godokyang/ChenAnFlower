'use strict';

import { createStore, applyMiddleware } from 'redux'
import rootReducer from './reducers'
import promiseMiddleWare from 'redux-promise'
import thunk from 'redux-thunk';

const configureStore = (initialState) => {
  return createStore(
    rootReducer,
    initialState,
    applyMiddleware(promiseMiddleWare, thunk)
  )
}

export default configureStore
