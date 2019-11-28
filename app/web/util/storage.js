class webStorage {
  set(key, value) {
    const newValue = JSON.parse(JSON.stringify(value))
    const storage = window.localStorage
    if (!storage[key]) {
      storage[key] = JSON.stringify(newValue)
      return
    }
    storage.setItem(key, JSON.stringify(newValue))
  }

  get(key, defaultValue) {
    const storage = window.localStorage
    return storage.getItem(key) ? JSON.parse(storage.getItem(key)) : defaultValue
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