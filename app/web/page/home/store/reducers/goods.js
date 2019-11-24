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

  case actionTypes.SHOW_BIG_PICS:
    newState.bigPicIndex = action.data.index
    newState.bigPics = [...Array.isArray(action.data.bigPics) ? action.data.bigPics : [action.data.bigPics]];
    break;
  case actionTypes.HIDE_BIG_PICS:
    newState.bigPics = [...[]];
    break;
  default:
    break;
  }

  return newState;
}

export {goodsHandle}