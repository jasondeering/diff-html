
fs = require 'fs'
open = require 'open'
git = require 'gift'
_ = require 'underscore'

parser = require('./diff-parser')

markupCode = (diffLines) ->
  diffClasses = {
    "d": "file",
    "i": "file",
    "@": "info",
    "-": "delete",
    "+": "insert",
    " ": "context"
  }

  escape = (str) ->
    return str
      .replace( /&/g, "&amp;" )
      .replace( /</g, "&lt;" )
      .replace( />/g, "&gt;" )
      .replace( /\t/g, "    " )

  _.map diffLines, (line) ->
    "<pre class='#{ diffClasses[line.charAt(0)] }'>#{ escape(line) }</pre>"
  .join("\n")

diffLines = (diff) ->
  _.chain(diff.split('\n'))
  .filter (line) -> 
    unless line 
      return false
    else if line.match(/^@@/) 
      return false
    else if line.match(/^\-\-\-/) 
      return false
    else if line.match(/^\+\+\+/) 
      return false
    else if line.match(/^index/) 
      return false
    return true
  .value()

module.exports = () ->
  diffHtml = ""
  dir = process.cwd()
  pageTemplate = fs.readFileSync "#{__dirname}/../template.html", "utf8"

  repo = git dir

  repo.commits (err, commits) ->
    repo.diff commits[1], commits[2], (err, diffs) ->
      diffs.forEach((diff, i) ->
        diffHtml += "<h2>#{diff.b_path}</h2>
          <div class='file-diff'>
            <div>
              #{markupCode diffLines(diff.diff)}
            </div>
          </div>"
      )
      fs.writeFileSync("#{dir}/tmp/diff.html", pageTemplate.replace("{{diff}}", diffHtml))
      open "#{dir}/tmp/diff.html"
