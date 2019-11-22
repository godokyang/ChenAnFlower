import * as actionTypes from '../constants';

const goodsHandle = (state, action) => {
  console.log('=================statestate===================');
  console.log(state, action);
  console.log('====================================');
  const newState = Object.assign({}, state);
  if (action.type === actionTypes.LOAD_GOODS) {
    const list = Array.isArray(action.data) ? action.data : [action.data];
    newState.list = [...newState.list, ...list];
  }
  return newState;
}

export {goodsHandle}