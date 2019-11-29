import _lodash from 'lodash'
import * as actionTypes from '../constants'

const setTab = tab => {
  return {
    type: actionTypes.SET_CURRENT_TAB,
    tab
  }
}

export {setTab}