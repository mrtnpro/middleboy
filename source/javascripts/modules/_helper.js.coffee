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

# Animated scroll helper
window.animatedScrollTo = ( options, callback = -> ) ->
  $("body").animate { scrollTop: options.top }, options.speed || 500, "swing", -> callback()