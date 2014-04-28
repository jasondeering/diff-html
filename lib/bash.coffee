
Bash = () ->
  _opt_to_args = (options) ->
    args = for key, val of options
      prepend = if key.length == 1 then "-" else "--"
      assign = if key.length == 1 then " " else "="
      if val == true
        "#{prepend}#{key}"
      else unless val == false
        "#{prepend}#{key}#{assign}#{val}"
      else
        ""
    return args.join " "

  return {
    options_to_args: _opt_to_args
  }

module.exports = Bash()