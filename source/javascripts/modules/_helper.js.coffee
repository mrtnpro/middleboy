# Async load script tag
((doc, script) ->
  js = undefined
  s = doc.getElementsByTagName(script)[0]
  window.loadScript = ( url, id, callback = -> ) ->
    return if doc.getElementById(id)
    js = doc.createElement(script)
    js.async = true
    js.src = url
    id and (js.id = id)
    s.addEventListener "load", ((e) -> callback null, e), false
    s.parentNode.insertBefore js, s
) document, "script"

# Timing function shorthand
window.delay    = (ms, func) -> setTimeout func, ms
window.interval = (ms, func) -> setInterval func, ms

# Debounce function (e.g. for window resize event)
window.debounce = (func, wait, immediate) ->
  timeout = undefined
  ->
    context = this
    args = arguments
    later = ->
      timeout = null
      func.apply context, args  unless immediate

    callNow = immediate and not timeout
    clearTimeout timeout
    timeout = setTimeout(later, wait)
    func.apply context, args  if callNow

# Animated scroll helper
window.animatedScrollTo = ( options, callback = -> ) ->
  $("body").animate { scrollTop: options.top }, options.speed || 500, "swing", -> callback()