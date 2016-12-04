class this.RelationEditorSynsetControl
  constructor: (@container, @name) ->
    @container = $(@container)
    @synsetsContainer = @container.find('.synsets')
    @synsetsTemplate = $('#synsets-tpl').text()

  init: ->
    @initSearchForm()

  isSynsetChosen: ->
    @synsetsContainer.find('input:checked').length

  chosenSynset: ->
    @synsetsContainer.find('input:checked').val()

  #private

  initSearchForm: ->
    @container.find('.search-synsets').autocomplete
      serviceUrl: '/words.json'
      paramName: 'q'
      params:
        limit: 5
      minChars: 2
      deferRequestBy: 100
      transformResult: (response, _) =>
        @transformResult(response)
      onSelect: (item) =>
        @loadSynsets(item.data)


  transformResult: (response) ->
    return {
      suggestions:
        $.map JSON.parse(response), (item) ->
          value: item.word
          data: item.id
    }

  loadSynsets: (word_id) ->
    $.get 'editor/word.json?word_id=' + word_id, (data) =>
      @clearSynsets()
      @renderSynsets(data.synsets)
      @bindSynsetEvents()
      $(document).trigger 'synsetChosen'

  clearSynsets: ->
    @synsetsContainer.html('')

  renderSynsets: (synsets) ->
    html = Mustache.render(@synsetsTemplate, {synsets: synsets, name: @name})
    @synsetsContainer.html(html)

  bindSynsetEvents: ->
    @synsetsContainer.find('input[type=radio]').on 'click', ->
      $(document).trigger 'synsetChosen'
