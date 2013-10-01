/*

[Дима] Слева в разделе синонимов не должно быть самого слова.
[Дима] Возможность добавить слово, которого пока нет в базе. После этого в базе должен появиться пустой wordEntry.

Наверху, рядом со словом сделать кнопку «готово». Она должна быть основная, а кнопка «выбрать другое слово» вспомогательной. Готово работает как написано на прототипе.

Иметь возможность скрывать заведомо бесполезные определения (у самого слова и у синонимов). Иметь возможность вернуть обратно скрытые определения. Кнопкой «показать все» или перезагрузкой страницы.
 
«Добавить определение на основе существующего».

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

        if (this.isWordPicked()) {
          this.loadWord(this.wordCookie())
        } else {
          this.wordPickerDialog()
        }

        this.handlePickWordBtn()
        this.handleWordDoneBtn()
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
          onRemoveDefinition: $.proxy(function(definitionId) {
            this.definition.resetInactiveDefinition(definitionId)
          }, this),
          onAfterRender: $.proxy(function(data) {
            this.definition.inactivateDefinitions(this.currentSynset.definitionIds())
            this.synsets.updateSelected(data.selected_synset)
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
          onChange: $.proxy(function(definition) {
            this.currentSynset.addDefinition(this.definition.current())
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
          this.wordPickerDialog()
        }, this))
      },

      handleWordDoneBtn: function() {
        $('#word-is-done').on('click', $.proxy(function(e) {
          e.preventDefault()
          this.loadWord(this.wordId, true)
        }, this))
      },

      wordPickerDialog: function() {
        this.wordPicker = new o.wordPicker($('.word-picker-modal'), {
          allowClose : this.allowCloseWordPickerDialog(),
          onPickWord : $.proxy(function(word, wordId) {
            this.loadWord(wordId)
          }, this)
        })

        this.wordPicker.show()
      },

      allowCloseWordPickerDialog: function() {
        return this.wordId != undefined
      },

      isWordPicked: function() {
        return this.wordCookie() != undefined
      },

      wordCookie: function() {
        return $.cookie('wordId')
      },

      loadWord: function(wordId, next) {
        var params = { word_id: wordId }

        if (next != undefined) {
          params['next'] = true
        }

        console.log(params)

        $.getJSON(o.options.uri, params, $.proxy(function(data) {
          this.build(data)
        }, this))
      }
    }

    return this.each(function() {
      new $.fn.editor(this)
    })
  }
})(jQuery);
