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
/*
  + Текущий синсет можно сохранить тогда, когда у него есть хоть одно слово и определение.
  + Если он валиден, то кнопка Сохранить становится активной
  + При наведении на кнопку доб в тек синсет - тек синсет подсвечивается
  - Поиск и добавление синонима
  - Сохранение текущего слова и переход к другому слову (тут надо понять что и как делать)
  + Выбор и рендеринг синсета из списка
  + В тек синсете делать активной кнопку отмена только если синсет был изменен (добавлены или удалены слова/определения)
  !- Создание определения при добавлении его в тек синсет editor#create_definition
  - Его можно отменить. При сбросе тек синсета надо брать данные с сервера
  - При сохранении тек синсета получать с сервера данные и рендерить их заново в тек. синсете.
  - Если текущий синсет не показывается, то кнопка добавления в него не активируется.
  - Походу, не надо создавать на сервере определения тек синсета при добавлении их в синсет, т.к.
    при сбросе синсета привязанное к нему определение не отвяжется.
  - При сохранении синсета отвязывать от него все ранее привязанные слова и определения. И привязывать те,
    которые пришли от клиента.
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
          }, this),
          onBtnOver: $.proxy(function() {
            this.currentSynset.highlight()
          }, this),
          onBtnOut: $.proxy(function() {
            this.currentSynset.highlight()
          }, this),
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
          onAdd: $.proxy(function(data, synset) {
            this.currentSynset.render(data)
          }, this),
          onSelect: $.proxy(function(data, synset) {
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
