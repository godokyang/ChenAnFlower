import * as actionTypes from '../constants';

const initialState = 'BED'

const tabHandle = (state = initialState, action) => {
  if (action.type === actionTypes.SET_CURRENT_TAB) {
    return action.tab;
  }
  return state
}

export {tabHandle}