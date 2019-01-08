
module.exports = () ->
  target = arguments[0]
  from = 1
  to = arguments.length
  if typeof target is 'boolean'
    inverse = !! target
    target = arguments[1]
    from = 2
  target ?= {}
  # Handle case when target is a string or something (possible in deep copy)
  if typeof target isnt "object" and typeof target isnt 'function'
    target = {}
  for i in [from ... to]
    # Only deal with non-null/undefined values
    if (options = arguments[ i ]) isnt null
      # Extend the base object
      for name of options 
        src = target[ name ]
        copy = options[ name ]
        # Prevent never-ending loop
        continue if target is copy
        # Recurse if we're merging plain objects
        if copy? and typeof copy is 'object' and not Array.isArray(copy) and copy not instanceof RegExp and not Buffer.isBuffer copy
          clone = src and ( if src and typeof src is 'object' then src else {} )
          # Never move original objects, clone them
          target[ name ] = module.exports false, clone, copy
        # Don't bring in undefined values
        else if copy isnt undefined
          copy = copy.slice(0) if Array.isArray copy
          target[ name ] = copy unless inverse and typeof target[ name ] isnt 'undefined'
  # Return the modified object
  target
