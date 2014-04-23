
fs = require 'fs'
open = require 'open'
git = require 'gift'
_ = require 'underscore'

dir = process.cwd()

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

gitDiffParser = (commitA, commitB, cb) ->
  spawn = require('child_process').spawn
  parser = require './parser'

  diffHtml = ""
  out = ""
  err = ""

  child = spawn "git", ["diff", commitA.id, commitB.id]
  child.stdout.on 'data', (chunk) -> out += chunk
  child.stderr.on 'data', (chunk) -> err += chunk

  child.on 'close', ->

    files = parser.parse(out)

    files.forEach((file, i) ->
      diffHtml += "<h2>#{file.name}</h2>
        <div class='file-diff'>
          <div>
            #{markupCode _.pluck(file.lines, 'text')}
          </div>
        </div>"
    )

    cb diffHtml

generateHtml = (text) ->
  pageTemplate = fs.readFileSync "#{__dirname}/../template.html", "utf8"
  fs.writeFileSync("#{dir}/tmp/diff.html", pageTemplate.replace("{{diff}}", text))
  open "#{dir}/tmp/diff.html"

module.exports = (useGit) ->
  repo = git dir
  repo.commits (err, commits) ->
    gitDiffParser commits[1], commits[0], generateHtml
