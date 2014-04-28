module.exports = {

  options_to_args: (options) ->
    args = for key, val of options
      prepend = if key.length == 1 then "-" else "--"
      assign = if key.length == 1 then " " else "="
      if val == true
        "#{prepend}#{key}"
      else unless val == false
        "#{prepend}#{key}#{assign}#{val}"
      else
        ""
    args.join " "

}