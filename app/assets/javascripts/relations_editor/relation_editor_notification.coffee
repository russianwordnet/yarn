class this.RelationEditorNotification
  constructor: ->
    @message = $('.relation-editor-notification')

  success: ->
    @message.fadeIn 500, =>
      @message.delay(800).fadeOut 500