import * as actionTypes from '../constants';

const initialState = {
}

const mappingIndexArr = (state, indexArr, value) => {
  let newState = [...state]
  let temp = []
  for (let index = 0; index < indexArr.length; index++) {
    const element = indexArr[index];
    temp = newState[element]
  }
  temp.children = value
  return newState
}

const confirmOrder = (state = initialState, action) => {
  if (action.type === actionTypes.CONFIRM_ORDER) {
    return action.data
  }
  return state
}

const setCurOrgin = (state = initialState, action) => {
  if (action.type === actionTypes.SET_ORGIN) {
    return action.data
  }
  return state
}

const setSubOrgin = (state = [], action) => {
  let newState = [...state]
  if (action.type === actionTypes.SET_SUB_ORGIN) {
    newState = newState.length === 0 ? [...action.data.orgin] : mappingIndexArr(newState, action.data.indexArr, action.data.orgin)
    return newState
  }
  return state
}

export {confirmOrder, setCurOrgin, setSubOrgin}