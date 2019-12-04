import * as actionTypes from '../constants';

const initialState = {
}

const checkUser = (state = initialState, action) => {
  let newState = Object.assign({}, state);
  switch (action.type) {
  case actionTypes.CHECK_USER:
    // newState.goodsList = [...newState.goodsList, ...Array.isArray(action.data) ? action.data : [action.data]]
    newState = action.data
    break
  default:
    break;
  }
  return newState;
}

export {checkUser}