export default class webStorage {
  get status(){
    if (window) {
      return window.localStorage && window.sessionStorage
    }
    return false
  }
  set(key,value) {
    if (!window) {
      return
    }
    const storage = window.localStorage || window.sessionStorage
    if (!storage[key]) {
      storage[key] = value
      return
    }
    storage.setItem(key,value)
  }

  get(key) {
    if (!window) {
      return
    }
    const storage = window.localStorage || window.sessionStorage
    return storage.getItem(key)
  }

  removeAll() {
    if (!window) {
      return
    }
    const storage = window.localStorage || window.sessionStorage
    storage.clear()
  }

  remove(key) {
    if (!window) {
      return
    }
    const storage = window.localStorage || window.sessionStorage
    storage.removeItem(key)
  }
}