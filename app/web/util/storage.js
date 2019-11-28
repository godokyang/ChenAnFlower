class webStorage {
  set(key,value) {
    const storage = window.localStorage
    if (!storage[key]) {
      storage[key] = value
      return
    }
    storage.setItem(key,value)
  }

  get(key, defaultValue) {
    const storage = window.localStorage
    return storage.getItem(key) || defaultValue
  }

  removeAll() {
    const storage = window.localStorage
    storage.clear()
  }

  remove(key) {
    const storage = window.localStorage
    storage.removeItem(key)
  }
}

export default new webStorage()