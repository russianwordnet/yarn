class RelationEditor
  constructor: ->
    @buttonsContainer = $('#relation-buttons')
    @notification = new RelationEditorNotification()

  init: ->
    return unless @relationEditorPage()

    @initButtons()
    @initSynsetControlls()

  onSynsetChosen: ->
    all_checked = @synsetControls.every (control) ->
      control.isSynsetChosen()

    if all_checked then @enableButtons() else @disableButtons()

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

  selectRelation: (data) ->
    synset1 = if data.reverse then @synsetControls[0] else @synsetControls[1]
    synset2 = if data.reverse then @synsetControls[1] else @synsetControls[0]

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