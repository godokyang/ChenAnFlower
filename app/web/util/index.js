import _lodash from 'lodash'

const depTypeOf = (params) => {
  const type = Object.prototype.toString.call(params)
  if (type === '[object Null]') {
    return null
  }
  if (type === '[object Undefined]') {
    return 'undefined'
  }
  if (type === '[object String]') {
    return 'string'
  }
  if (type === '[object Number]') {
    return 'number'
  }
  if (type === '[object Boolean]') {
    return 'boolean'
  }
  if (type === '[object Function]') {
    return 'function'
  }
  if (type === '[object Array]') {
    return 'array'
  }
  if (type === '[object Object]') {
    return 'object'
  }
  if (type === '[object JSON]') {
    return 'json'
  }
  if (type === '[object RegExp]') {
    return 'regexp'
  }
  return 'unknown'
}

const throttle = function (func, wait, options) {
  let queue = [], context, args
  // let now = _lodash.now()
  let previous = 0

  if (!options) options = {lastLoad: true}

  const later = function() {
    if (options.lastLoad && queue.length == 1) {
      func.apply(context, args)
      context = args = null
      previous = 0
    }
    queue.shift()
  }

  const throttled = function() {
    let now = _lodash.now()
    let runner = (wait - (now - previous)) <= 0

    if (runner) {
      previous = now
      console.log(previous)
      func.apply(context, args)
    } else {
      queue.push(now)
      setTimeout(later, wait)
    }
  }
  // 执行 _.throttle 返回 throttled 函数
  return throttled;
};



export { depTypeOf, throttle }