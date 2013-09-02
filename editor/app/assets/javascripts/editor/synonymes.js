(function( $ ) {
  $.fn.EditorSynonymes = function(data, o) {
    var o = $.extend({
      placeholder         : $('#synonymes-placeholder'),
      definitionsTemplate : $('#listing-tpl').text(),
      accordionTemplate   : $('#accordion-tpl').text(),
      onExpandAccordion   : function(accordion) { },
      onAddWordBtnOver    : function(word) { },
      onAddWordBtnOut     : function(word) { },
      onAddWordClick      : function(word) { },
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

      this.accordion
        .on('show', this.toggleIcon)
        .on('hide', this.toggleIcon)
        .on('shown', $.proxy(this.fireOnExpandAccordion, this))
        .on('hidden', $.proxy(this.fireOnExpandAccordion, this))

      this.addWordMouseInteraction()
    },

    render: function() {
      var synonymes     = this.data.synonymes
      var definitions   = this.data.definitions
      var counter       = 0
      var accordionView = {
        count          : function() { return function (text, render) { return counter++ } },
        hasDefinitions : function() { return definitions.length > 0 },
        expandFirst    : function() { return counter == 1 },
        synonymes      : synonymes
      }

      this.accordion = $(Mustache.render(this.o.accordionTemplate, accordionView, {
        definitions: this.o.definitionsTemplate
      }))

      this.o.placeholder.html(this.accordion)
    },

    toggleIcon: function(e) {
      var icon = $(e.target).prev('.accordion-heading').find('a > i.icon')

      if (icon.hasClass('icon-plus')) {
        icon.removeClass('icon-plus').addClass('icon-minus')
      } else {
        icon.removeClass('icon-minus').addClass('icon-plus')
      }
    },

    // Handle add-word mouse interaction
    addWordMouseInteraction: function() {
      this.accordion.find('.add-word').hover(
        $.proxy(function(e) { this.o.onAddWordBtnOver($(e.currentTarget).data('word'))}, this),
        $.proxy(function(e) { this.o.onAddWordBtnOut($(e.currentTarget).data('word'))}, this)
      ).on('click', $.proxy(function(e) {
        e.stopPropagation()
        e.preventDefault()
        this.o.onAddWordBtnClick($(e.currentTarget).data('word'))
      }, this))
    },

    fireOnExpandAccordion: function() {
      this.o.onExpandAccordion(this.accordion)
    }
  }
})(jQuery);
