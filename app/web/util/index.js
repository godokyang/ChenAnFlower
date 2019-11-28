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

export { depTypeOf }