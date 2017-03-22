class RelationEditor
  constructor: ->
    @buttonsContainer = $('#relation-buttons')
    @notification = new RelationEditorNotification()
    @repo = new RelationEditorRelationsRepo()

  init: ->
    return unless @relationEditorPage()

    @initButtons()
    @initSynsetControlls()

  onSynsetChosen: ->
    all_checked = @synsetControls.every (control) ->
      control.isSynsetChosen()

    if all_checked
      @enableButtons()
      @showExistingRelations()
    else
      @disableButtons()

  onWordChosen: ->
    @loadExistingRelations()

  #private

  relationEditorPage: ->
    $('.relation-editor').length

  initButtons: ->
    @disableButtons()
    @buttonsContainer.find('.btn').on 'click', =>
      button = $(event.currentTarget)

      return if button.hasClass 'disabled'
      @selectRelation
        type:    button.data 'type'
        reverse: button.is '[data-reverse]'

  initSynsetControlls: ->
    @synsetControls = [
      new RelationEditorSynsetControl($.find('#word1'), 'word1'),
      new RelationEditorSynsetControl($.find('#word2'), 'word2')
    ]

    $.each @synsetControls, (idx, control) ->
      control.init()

  loadExistingRelations: ->
    word1 = @synsetControls[0].chosenWord()
    word2 = @synsetControls[1].chosenWord()

    return unless word1 && word2

    @repo.load_for word1, word2

  showExistingRelations: ->
    synset1 = @synsetControls[0].chosenSynset()
    synset2 = @synsetControls[1].chosenSynset()

    relation = @repo.relation_for synset1, synset2
    @showRelation(relation)

  selectRelation: (data) ->
    synset1 = if data.reverse then @synsetControls[1] else @synsetControls[0]
    synset2 = if data.reverse then @synsetControls[0] else @synsetControls[1]

    $.ajax
      url: '/relations_editor/save.json'
      dataType: 'json'
      type: 'POST'
      data:
        relation:
          synset1_id: synset1.chosenSynset()
          synset2_id: synset2.chosenSynset()
          relation_type: data.type
      success: =>
        @showSuccessMessage()
        @updateRelationButton(data.type, data.reverse)

  updateRelationButton: (relation, reverse) ->
    synset1 = @synsetControls[0].chosenSynset()
    synset2 = @synsetControls[1].chosenSynset()

    @repo.update_relation(synset1, synset2, relation, reverse)
    @showExistingRelations()

  showRelation: (relation) ->
    @buttonsContainer.find('.btn').removeClass('selected')
    return unless relation

    query = "[data-type=#{relation.relation_type}]"
    if relation.reverse
      query += '[data-reverse]'
    else
      query += ':not([data-reverse])'

    @buttonsContainer.find(query).addClass('selected')


  showSuccessMessage: ->
    @notification.success()

  enableButtons: ->
    @buttonsContainer.find('.btn').
      removeClass('disabled').
      addClass('btn-info')

  disableButtons: ->
    @buttonsContainer.find('.btn').
      addClass('disabled').
      removeClass('btn-info')

$(document).ready ->
  window.relationEditor = new RelationEditor()
  window.relationEditor.init()

$(document).on 'synsetChosen', ->
  window.relationEditor.onSynsetChosen()

$(document).on 'wordChosen', ->
  window.relationEditor.onWordChosen()
