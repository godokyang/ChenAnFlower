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

const submitPartOrder = (state = initialState, action) => {
  if (action.type === actionTypes.SUBMIT_PART_ORDER) {
    return Object.assign({}, state, action.data)
  }
  return state
}

export {confirmOrder, setCurOrgin, submitPartOrder}