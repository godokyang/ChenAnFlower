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
      func.apply(context, args)
    } else {
      queue.push(now)
      setTimeout(later, wait)
    }
  }
  // 执行 _.throttle 返回 throttled 函数
  return throttled;
};

const getMyDate = (str) => {
  const oDate = new Date(str),
    oYear = oDate.getFullYear(),
    oMonth = oDate.getMonth()+1,
    oDay = oDate.getDate(),
    oHour = oDate.getHours(),
    oMin = oDate.getMinutes(),
    oSen = oDate.getSeconds(),
    oTime = oYear +'-'+ addZero(oMonth) +'-'+ addZero(oDay) +' '+ addZero(oHour) +':'+
addZero(oMin) +':'+addZero(oSen);
  return oTime;
}

//补零操作
const addZero = (num) => {
  if(parseInt(num) < 10){
    num = '0'+num;
  }
  return num;
}


export { depTypeOf, throttle, getMyDate }