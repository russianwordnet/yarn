/*
  События приложения:
  - Загрузка данных по слову
  - Клик по кнопке добавления слова в тек. синсет
  - Клик по кнопке удаления слова из тек. синсета
  - Выбрано определение
  - Убран "фокус" с текущего определения
  - Выбран синсет
  - Добавлен пустой синсет
  - Добавлено определение в тек. синсет
  - Удалено определение из тек. синсета
*/

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
      definitions   : $.fn.EditorDefinitions,
      definition    : $.fn.EditorDefinition,
      synonymes     : $.fn.EditorSynonymes,
      synsets       : $.fn.EditorSynsets,
      currentSynset : $.fn.EditorCurrentSynset,
      addToCurrentSynsetButton: $.fn.EditorAddToCurrentSynsetButton,
      options : {
        placeholder: "Введите слово",
        allowClear:  true,
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
      addToCurrentSynsetButton : null,
      definitions   : null,
      definition    : null,
      synonymes     : null,
      synsets       : null,
      currentSynset : null,
      editorUi      : null,
      word          : null,
      data          : null,

      // Initialize editor
      initialize: function(editorUi) {
        this.editorUi = $(editorUi)

        o.options.wordInput.select2({
          placeholder: o.options.placeholder,
          allowClear:  o.options.allowClear
        }).on("change", $.proxy(function(e) { // When select a word
          $.getJSON(o.options.uri, { word_id: o.options.wordInput.val() }, $.proxy(function(data) {
            this.build(data)
          }, this))
        }, this))
      },

      build: function(data) {
        this.word   = data.word
        this.wordId = data.id
        this.data   = data

        this.enable()

        // Current synset area
        this.currentSynset = new o.currentSynset({})

        // Big 'addToCurrentSynsetButton' button
        this.addToCurrentSynsetButton = new o.addToCurrentSynsetButton({
          onClick: $.proxy(function() {
            this.currentSynset.addDefinition(this.definition.current())
          }, this)
        })

        // Create definitions area
        this.definitions = new o.definitions(this.data, {
          onAfterRender: $.proxy(function() {
            this.addToCurrentSynsetButton.adjustHeight()
          }, this)
        })

        // Create synonymes area
        this.synonymes = new o.synonymes(this.data, {
          onExpandAccordion : $.proxy(function(accordion) {
            this.addToCurrentSynsetButton.adjustHeight()
          }, this),
          onAddWordBtnOver: $.proxy(function(e) {
            this.currentSynset.highlightWords()
          }, this),
          onAddWordBtnOut: $.proxy(function(e) {
            this.currentSynset.highlightWords()
          }, this),
          onAddWordBtnClick: $.proxy(function(word) {
            this.currentSynset.addWord(word)
          }, this),
          onAfterRender: $.proxy(function() {
            this.addToCurrentSynsetButton.adjustHeight()
          }, this)
        })

        // Create synsets area
        this.synsets = new o.synsets(this.data, {
          onAdd: $.proxy(function(data, newSynset) {
            this.currentSynset.render(data)
          }, this)
        })

        // Handle current definition
        this.definition = new o.definition({
          onSelect: $.proxy(function(definition) {
            this.addToCurrentSynsetButton.enable()
          }, this),
          onBlur: $.proxy(function(definition) {
            this.addToCurrentSynsetButton.disable()
          }, this)
        })

        o.onDataLoad(this.data)
        this.updateCurrentWordPlaceholders()
      },

      enable: function() {
        o.options.editorArea.show()
      },

      updateCurrentWordPlaceholders: function() {
        o.options.currentWord.html(this.word)
      },
    }

    return this.each(function() {
      new $.fn.editor(this)
    })
  }
})(jQuery);


/*
var Editor = {
  wordId:        null,
  leftPane:      $('#left-pane'),
  rightPane:     $('#right-pane'),
  actionPane:    $('#action-pane'),
  currentWords:  $('#current-words'),
  selectedWords: [],
  isCurrentSynsetChanged: false,
  currentSynset: $('#current-synset'),
  currentSynsetDefinitions: $('#current-synset ol'),
  rightColumn:   $('#right-column'),
  editorArea:    $('#editor-area'),
  currentDefinition: function() { return $('.definitions ul li.active') },

  listingTemplate: $('#listing-tpl').text(),
  accordionTemplate: $('#accordion-tpl').text(),
  synsetsTemplate: $('#synsets-tpl').text(),
  addDefinitionFormTemplate: $('#add-definition-form-tpl').text(),
  wordDefinitionsPlaceholder: $('#word-definitions-placeholder'),
  synonymesPlaceholder: $('#synonymes-placeholder'),
  synsetsPlaceholder: $('#synsets-placeholder'),
  addToCurrentSynsetBtn: $('#add-to-current-synset-btn'),
  synonymes: function() { return $('#synonymes') },
  synsets: $('#synsets'),
  currentWord: $('.current-word'),
  addWord: function() { return $('.add-word') },
  definitionsLists: function() { return $('.definitions ul') },

  // Handle hover on add-to-current-synset-btn
  handleCurrentSynsetBtnHover: function() {
    currentSynset = this.currentSynset

    this.addToCurrentSynsetBtn.hover(function(e) {
      if (!$(this).hasClass('disabled')) currentSynset.addClass('active')
    }, function() {
      currentSynset.removeClass('active')
    })
  },

  // Handle click on add-to-current-synset-btn
  handleCurrentSynsetBtn: function() {
    var that = this
    currentDefinition = this.currentDefinition()
    currentSynsetDefinitions = this.currentSynsetDefinitions

    this.addToCurrentSynsetBtn.click(function(e) {
      e.stopPropagation()

      if (currentSynsetDefinitions.find('[data-id="' + currentDefinition.data('id') + '"]').length == 0) {
        var icon = $(document.createElement('i'))
          .attr('title', 'Удалить')
          .addClass('icon icon-remove')
          .click(function() {
            $(this).closest('li').remove()
          })

        newDefinition = currentDefinition
          .clone()
          .removeClass('active')
          .append(icon)

        that.createWord(newDefinition.data('word'))
        currentSynsetDefinitions.append(newDefinition)
        this.isCurrentSynsetChanged = true
      }
    })
  },

  // Handle word definitions lists
  handleDefinitionsLists: function() {
    currentDefinition = this.currentDefinition()
    addToCurrentSynsetBtn = this.addToCurrentSynsetBtn
    
    this.definitionsLists().on('click', 'li', function(e) {
      e.stopPropagation()

      if (currentDefinition != null) {
        currentDefinition.removeClass('active')
      }

      currentDefinition = $(this).addClass('active')

      // Make add-to-current-synset-btn active
      addToCurrentSynsetBtn.removeClass('disabled')
    })
  },


  notifyCurrentSynsetChanged: function() {
    if (this.isCurrentSynsetChanged) {
      bootbox.alert('Текущий синсет был изменён. Необходимо сохранить изменения.')
    }
  }
}

*/
