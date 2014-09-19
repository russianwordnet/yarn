//= require editor/word_picker
//= require editor/definition
//= require editor/synonymes
//= require editor/synsets
//= require editor/current_synset
//= require editor/marks_picker

(function( $ ) {
  $.fn.editor = function(o) {
    // Editor options
    var o = $.extend({
      wordPicker    : $.fn.WordPicker,
      definition    : $.fn.EditorDefinition,
      synonymes     : $.fn.EditorSynonymes,
      synsets       : $.fn.EditorSynsets,
      currentSynset : $.fn.EditorCurrentSynset,
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
      data          : null,
      currentSynset : null,
      // Initialize editor
      initialize: function(editorUi) {
        this.editorUi = $(editorUi)

        if (this.isWordPicked()) {
          this.loadWord(this.wordCookie(), false, true)
        } else {
          this.wordPickerDialog()
        }

        this.handlePickWordBtn()
        this.handleWordDoneBtn()
        this.handleDeleteWordBtn()
      },

      build: function(data) {
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
            //this.definition.inactivateDefinitions(this.currentSynset.definitionIds())
            this.synsets.updateSelected(data.selected_synset)
          }, this),
        })

        // Create synonymes area
        this.synonymes = new o.synonymes(this.data, {
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
            if (!this.currentSynset.isDisplayed()) {
              this.definition.clear()
            }
          }, this),
          onChange: $.proxy(function(definition) {
            this.currentSynset.addDefinition(this.definition.current())
          }, this),
          onAdd: $.proxy(function(definition) {
            if(this.currentSynset.isDisplayed()) {
              console.log(definition)
              this.currentSynset.addDefinition(definition)
            }
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

      handleDeleteWordBtn: function() {
        $('#delete-word').on('click', $.proxy(function(e) {
          e.preventDefault()
          this.deleteWord()
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
          allowClose : true,
          onPickWord : $.proxy(function(word, wordId) {
            this.loadWord(wordId)
          }, this)
        })

        this.wordPicker.show()
      },

      isWordPicked: function() {
        return this.wordCookie() != undefined
      },

      isSynsetPicked: function() {
        return this.synsetCookie() != undefined
      },

      wordCookie: function() {
        return $.cookie('wordId')
      },

      synsetCookie: function() {
        return $.cookie('synsetId')
      },

      loadWord: function(wordId, next, needLoadSynset) {
        var params = { word_id: wordId }

        if (next != undefined && next != false) {
          params['next'] = true
        }

        $.getJSON(o.options.uri, params, $.proxy(function(data) {
          this.build(data)
          $.cookie('wordId', data.id)

          if(needLoadSynset && this.isSynsetPicked()) {
            this.loadSynset(this.synsetCookie())
          }
        }, this))
      },

      deleteWord: function() {
        var url = '/words/' + this.wordId + '.json'

        $.post(url, {_method : 'delete'}, $.proxy(function() {
          this.loadWord(this.wordId, true)
        }, this))
      },

      loadSynset: function(synsetId) {
        var id = this.synsetCookie()
        $.each(this.data.synsets, $.proxy(function(index, synset) {
          if(synset.id == id && synset.state == 'normal') {
            this.synsets.setSelected(id)
            this.currentSynset.load(id)
            return false
          }
        }, this)
        )

        $.cookie('synsetId', null)
      }
    }

    return this.each(function() {
      new $.fn.editor(this)
    })
  }
})(jQuery);
