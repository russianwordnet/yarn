class GetNextExample
  constructor: (@button) ->

  get: ->
    $.get @next_example_path(), (data) ->
      window.relationEditor.loadExample(data)

  # private

  next_example_path: ->
    @button.data('example-path')

$(document).ready ->
  $('#relation-next-example').on 'click', ->
    new GetNextExample($(this)).get()

