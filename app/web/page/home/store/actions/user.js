import _lodash from 'lodash'
import * as actionTypes from '../constants'
import * as api from '@webApi'

const getUserInfo = async (params) => {
  return async dispatch => {
    try {
      let res = await api.getUserInfo(params)
      const data = _lodash.get(res, 'data.data.user_info', {status: false})
      dispatch(checkUser(data))
    } catch (error) {
      console.error(`CHECKUSER ERROR: ${error}`);
    } 
  }
}

const checkUser = data => {
  return {
    type: actionTypes.CHECK_USER,
    data
  }
}

export {getUserInfo}