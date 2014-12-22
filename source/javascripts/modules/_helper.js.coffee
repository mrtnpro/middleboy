# Async load script tag
((doc, script) ->
  window.loadScript = (src, id, callback) ->
    return if doc.getElementById(id)
    s       = doc.createElement("script")
    s.type  = "text/" + (src.type or "javascript")
    s.src   = src.src or src
    s.async = false
    s.id    = id
    s.onreadystatechange = s.onload = ->
      state = s.readyState
      if not callback.done and (not state or /loaded|complete/.test(state))
        callback.done = true
        callback()
    # use body if available. more safe in IE
    (doc.body or head).appendChild s
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