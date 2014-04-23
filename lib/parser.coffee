
fs = require 'fs'
open = require 'open'
git = require 'gift'
_ = require 'underscore'

#diff = require('./diff')

class DiffFile
  constructor: (@path) ->
    @name = _.last @path.split('/')
    @lines = []

  setIndex: (line) ->
    match = line.match /^index\s+([^. ]+)\.\.({^. }+)/
    if match
      @from = match[1]
      @to = match[2]

  finishHeader: -> @headerParsed = true

  append: (line) ->
    @lines.push line

    #if line.type == 'chunk'
    #  match = line.text.match /@@\s+\-([^\s]+)\s+\+([^\s]+)/
    #else if line.type == 'context'
    #else if line.type == 'add'
    #else if line.type == 'delete'

class DiffLine
  constructor: (@text, @type) ->

module.exports.parse = (text) ->

  files = []
  currentFile = null

  lines = text.split("\n")
  lines.pop();

  lines.forEach (line) ->
    if line.match(/^diff/)
      path = line.replace(/diff --git a/, 'b')
      path = path.slice(0, (path.length - 1) / 2)
      path = path.replace(/^b\//, '')

      currentFile = new DiffFile(path)
      files.push(currentFile)

    else
      unless currentFile.headerParsed
        currentFile.setIndex(line) if line.match(/^index/)
        currentFile.finishHeader() if line.match(/^\+\+\+/)
      else
        if line.match(/^@@/)
          currentFile.append new DiffLine(line, 'chunk')
        else if line.match(/^-/)
          currentFile.append new DiffLine(line, 'delete')
        else if line.match(/^\+/)
          currentFile.append new DiffLine(line, 'add')
        else
          currentFile.append new DiffLine(line, 'context')

  return files
