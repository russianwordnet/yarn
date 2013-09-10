/*
  Доделать:
  - Поиск и добавление синонима
  - Сохранение текущего слова и переход к другому слову (тут надо понять что и как делать)

1) нужно как-нибудь подсветить автора синсета в списках, поскольку мы заводим отдельных юзеров для словарей
2) я сделал чтобы показывались id синсетов в окошке справа сверху, но какая-то скриптовая часть убирает id
при выделении
3) нужно сделать ссылочку на строчке с определением, которая отправит в новой вкладке браузера 
редактировать это определение
4) закончить ссылку "Добавить синоним". её никто не хочет обсуждать, но все хотят чтобы она работала.
такие молодцы все просто


$('#pick-word').on('click', $.proxy(function(e) {
  e.preventDefault()
  $('#word-picker-modal').modal('show')
}, this))

$('#word-picker-content').on('click', '.pagination a', $.proxy(function(e) {
  e.preventDefault()
  
  $.get($(e.currentTarget).attr('href'), $.proxy(function(data) {
    $('#word-picker-content').html(data)
  }, this))
}, this))
*/
//= require editor/word_picker
//= require editor/add_to_current_synset_button
//= require editor/definitions
//= require editor/definition
//= require editor/synonymes
//= require editor/synsets
//= require editor/current_synset

(function( $ ) {
  $.fn.editor = function(o) {
    // Editor options
    var o = $.extend({
      wordPicker    : $.fn.WordPicker,
      definitions   : $.fn.EditorDefinitions,
      definition    : $.fn.EditorDefinition,
      synonymes     : $.fn.EditorSynonymes,
      synsets       : $.fn.EditorSynsets,
      currentSynset : $.fn.EditorCurrentSynset,
      addToCurrentSynsetButton: $.fn.EditorAddToCurrentSynsetButton,
      options : {
        uri:         '/editor/word.json',
        wordInput:   $("#searchbar #word"),
        editorArea:  $('#editor-area'),
        currentWord: $('.current-word')
      },
      onDataLoad: function(data) {},
    }, o)

    // Global options
    $.fn.editorOptions = function() { return o }

    // Main object
    $.fn.editor = function(el) { this.initialize(el) }

    $.fn.editor.prototype = {
      // Initialize editor
      initialize: function(editorUi) {
        this.editorUi = $(editorUi)
        this.pickWord()
        this.handlePickWordBtn()
      },

      build: function(data) {
        this.addToCurrentSynsetButton = null
        this.definitions   = null
        this.definition    = null
        this.synonymes     = null
        this.synsets       = null
        this.currentSynset = null
        this.wordPicker    = null

        this.word   = data.word
        this.wordId = data.id
        this.data   = data

        this.enable()

        this.currentSynset = new o.currentSynset({
          onReset: $.proxy(function() {
            this.definition.resetInactive()
          }, this),
          onRemoveDefinition: $.proxy(function(definitionId) {
            this.definition.resetInactiveDefinition(definitionId)
          }, this),
          onAfterRender: $.proxy(function(data) {
            this.definition.inactivateDefinitions(this.currentSynset.definitionIds())
            this.synsets.updateSelected(data)
          }, this),
        })

        // Big 'addToCurrentSynsetButton' button
        this.addToCurrentSynsetButton = new o.addToCurrentSynsetButton({
          onClick: $.proxy(function() {
            if (this.currentSynset.isDisplayed()) {
              this.currentSynset.addDefinition(this.definition.current())
              this.currentSynset.highlightOff()
              this.definition.reset()
            }
          }, this),
          onBtnOver: $.proxy(function() {
            if (this.currentSynset.isDisplayed())
              this.currentSynset.highlightOn()
          }, this),
          onBtnOut: $.proxy(function() {
            if (this.currentSynset.isDisplayed())
              this.currentSynset.highlightOff()
          }, this),
        })

        // Create definitions area
        this.definitions = new o.definitions(this.data, {
          onAfterRender: $.proxy(function() {
            this.addToCurrentSynsetButton.adjustHeight()
            this.currentSynset.remove()
          }, this)
        })

        // Create synonymes area
        this.synonymes = new o.synonymes(this.data, {
          onExpandAccordion: $.proxy(function(accordion) {
            this.addToCurrentSynsetButton.adjustHeight()
          }, this),
          onAddWordBtnOver: $.proxy(function(e) {
            if (this.currentSynset.isDisplayed())
              this.currentSynset.highlightWords()
          }, this),
          onAddWordBtnOut: $.proxy(function(e) {
            if (this.currentSynset.isDisplayed())
              this.currentSynset.highlightWords()
          }, this),
          onAddWordBtnClick: $.proxy(function(word) {
            if (this.currentSynset.isDisplayed())
              this.currentSynset.addWord(word)
          }, this),
          onAfterRender: $.proxy(function() {
            this.addToCurrentSynsetButton.adjustHeight()
          }, this)
        })

        // Create synsets area
        this.synsets = new o.synsets(this.data, {
          onAdd: $.proxy(function(data, synset) {
            this.currentSynset.render(data)
          }, this),
          onSelect: $.proxy(function(synsetId) {
            this.currentSynset.load(synsetId)
            this.definition.resetInactive()
          }, this)
        })

        // Handle current definition
        this.definition = new o.definition({
          onSelect: $.proxy(function(definition) {
            if (this.currentSynset.isDisplayed()) {
              this.addToCurrentSynsetButton.enable()
            } else {
              this.definition.clear()
            }
          }, this),
          onBlur: $.proxy(function(definition) {
            if (this.currentSynset.isDisplayed())
              this.addToCurrentSynsetButton.disable()
          }, this)
        })

        o.onDataLoad(this.data)
        this.updateCurrentWordPlaceholders()
      },

      enable: function() {
        o.options.editorArea.show()
        $('#word-search').show()
      },

      updateCurrentWordPlaceholders: function() {
        o.options.currentWord.html(this.word)
      },

      handlePickWordBtn: function() {
        $('#pick-word').on('click', $.proxy(function(e) {
          e.preventDefault()
          this.pickWord()
        }, this))
      },

      pickWord: function() {
        this.wordPicker = new o.wordPicker($('.word-picker-modal'), {
          onPickWord: $.proxy(function(word, wordId) {
            $.getJSON(o.options.uri, { word_id: wordId }, $.proxy(function(data) {
              this.build(data)
            }, this))
          }, this)
        })

        this.wordPicker.show()
      }
    }

    return this.each(function() {
      new $.fn.editor(this)
    })
  }
})(jQuery);
