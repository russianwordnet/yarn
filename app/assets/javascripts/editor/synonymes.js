(function( $ ) {
  $.fn.EditorSynonymes = function(data, o) {
    var o = $.extend({
      placeholder         : $('#synonymes-placeholder'),
      definitionsTemplate : $('#listing-tpl').text(),
      accordionTemplate   : $('#accordion-tpl').text(),
      onExpandAccordion   : function(accordion) { },
      onAddWordBtnOver    : function(e) { },
      onAddWordBtnOut     : function(e) { },
      onAddWordClick      : function(word) { },
      onAfterRender       : function() {}
    }, o)

    this.initialize(data, o)
  }
  
  $.fn.EditorSynonymes.prototype = {
    data      : null,
    accordion : null,

    initialize: function(data, o) {
      this.data = data
      this.o    = o

      this.render()
    },

    render: function() {
      var synonymes     = this.data.synonymes
      var counter       = 0

      var accordionView = {
        count          : function() { return function (text, render) { return counter++ } },
        hasDefinitions : function() { return this.definitions.length > 0 },
        expandFirst    : function() { return counter == 1 },
        hasSamples     : function() { return this.samples != null },
        synonymes      : synonymes
      }

      this.accordion = $(Mustache.render(this.o.accordionTemplate, accordionView, {
        definitions: this.o.definitionsTemplate
      }))

      this.o.placeholder.html(this.accordion)
      this.o.onAfterRender()

      this.accordion
        .on('show', this.toggleIcon)
        .on('hide', this.toggleIcon)
        .on('shown', $.proxy(this.fireOnExpandAccordion, this))
        .on('hidden', $.proxy(this.fireOnExpandAccordion, this))

      this.addWordMouseInteraction()
      this.handleAddSynonym()
    },

    add: function(data) {
      if (this.accordion.find('[data-word-id=' + data.id + ']').length > 0) return;

      this.data.synonymes.push({
        word_id     : data.id,
        word        : data.word,
        definitions : data.definitions
      })

      this.render()
    },

    toggleIcon: function(e) {
      var icon = $(e.target).prev('.accordion-heading').find('a > i.icon')

      if (icon.hasClass('icon-caret-right')) {
        icon.removeClass('icon-caret-right').addClass('icon-caret-down')
      } else {
        icon.removeClass('icon-caret-down').addClass('icon-caret-right')
      }
    },

    // Handle add-word mouse interaction
    addWordMouseInteraction: function() {
      this.accordion.find('.add-word').hover(
        $.proxy(function(e) { this.o.onAddWordBtnOver(e) }, this),
        $.proxy(function(e) { this.o.onAddWordBtnOut(e) }, this)
      ).off('click', '**').on('click', $.proxy(function(e) {
        e.stopPropagation()
        e.preventDefault()

        this.o.onAddWordBtnClick({
          id   : $(e.currentTarget).data('word-id'),
          word : $(e.currentTarget).data('word')
        })
      }, this))
    },

    fireOnExpandAccordion: function() {
      this.o.onExpandAccordion(this.accordion)
    },

    handleAddSynonym: function() {
      $('#add-synonym').on('click', $.proxy(function(e) {
        e.preventDefault()
        
        var wordPicker = new $.fn.WordPicker($('.synonym-picker-modal'), {
          onPickWord: $.proxy(function(word, wordId) {
            $.getJSON('/editor/word.json', { word_id: wordId }, $.proxy(function(data) {
              this.add(data)
            }, this))
          }, this)
        })

        wordPicker.show()
      }, this))
    }
  }
})(jQuery);
