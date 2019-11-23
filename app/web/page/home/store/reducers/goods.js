import * as actionTypes from '../constants';

const goodsHandle = (state = {
  goodsList: [],
  bigPics: []
}, action) => {
  const newState = Object.assign({}, state);
  switch (action.type) {
  case actionTypes.LOAD_GOODS:
    newState.goodsList = [...newState.goodsList, ...Array.isArray(action.data) ? action.data : [action.data]]
    break

  case actionTypes.SHOW_GOODS_PIC:
    newState.bigPics = [...Array.isArray(action.data) ? action.data : [action.data]];
    break;
    
  default:
    break;
  }

  return newState;
}

export {goodsHandle}