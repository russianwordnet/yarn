class this.RelationEditorSynsetControl
  constructor: (@container, @name) ->
    @container = $(@container)
    @synsetsContainer = @container.find('.synsets')
    @synsetsTemplate = $('#synsets-tpl').text()
    @chosenWordId = null
    @synsets = []

  init: ->
    @initSearchForm()

  isSynsetChosen: ->
    @synsetsContainer.find('input:checked').length

  chosenSynset: ->
    @synsetsContainer.find('input:checked').val()

  chosenWord: ->
    @chosenWordId

  get: (synset_id) ->
    id = parseInt(synset_id)
    @synsets.find (synset) ->
      synset.id == id

  loadWord: (word_id) ->
    @reset()
    @chosenWordId = word_id
    @loadSynsets(word_id)
  #private

  reset: ->
    @chosenWordId = null
    @clearSynsets()


  initSearchForm: ->
    @container.find('.search-synsets').autocomplete
      serviceUrl: '/words.json'
      paramName: 'q'
      params:
        limit: 5
        non_empty: true
      minChars: 2
      deferRequestBy: 0,
      ajaxSettings:
        error: -> # Override default ajaxSetup
      transformResult: (response, _) =>
        @transformResult(response)
      onSelect: (item) =>
        @loadWord(item.data)


  transformResult: (response) ->
    return {
      suggestions:
        $.map JSON.parse(response), (item) ->
          value: item.word
          data: item.id
    }

  loadSynsets: (word_id) ->
    $.get 'editor/word.json?word_id=' + word_id, (data) =>
      @container.find('.search-synsets').val(data.word)
      @synsets = data.synsets
      @renderSynsets(data.synsets)
      @bindSynsetEvents()
      $(document).trigger 'wordChosen'

  clearSynsets: ->
    @synsetsContainer.html('')

  renderSynsets: (synsets) ->
    html = Mustache.render(@synsetsTemplate, {synsets: synsets, name: @name})
    @synsetsContainer.html(html)

  bindSynsetEvents: ->
    @synsetsContainer.find('input[type=radio]').on 'click', ->
      $(document).trigger 'synsetChosen'
