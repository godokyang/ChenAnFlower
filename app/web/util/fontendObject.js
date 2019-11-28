const _window = () => {
  let targetWin = null
  if (window) targetWin = window;
  const proxyWindow = new Proxy(targetWin, {
    get: function(target, key, receiver) {
      if (!targetWin) {
        return Reflect.get({nothing: () => {}}, 'nothing', receiver)
      }
      return Reflect.get(target, key, receiver)
    }
  })
  return proxyWindow
}

export {_window}