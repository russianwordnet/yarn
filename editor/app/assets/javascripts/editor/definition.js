(function( $ ) {
  $.fn.EditorDefinition = function(o) {
    var o = $.extend({
      lists         : $('#editor-area .definitions'),
      current       : $('.definitions li.active'),
      onSelect      : function(definition) {},
      onChange      : function(definition) {},
      onBlur        : function(definition) {}
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorDefinition.prototype = {
    currentDefinition : null,

    initialize: function(o) {
      this.o = o
      this.currentDefinition = this.o.current
      this.handleLists()
      this.handleBlur()
    },

    handleLists: function() {
      $('#editor-area').on('click', '.definitions li', $.proxy(function(e) {
        e.stopPropagation()

        if (this.currentDefinition != null) {
          this.currentDefinition.removeClass('active')
        }

        this.currentDefinition = $(e.currentTarget).addClass('active')
        this.o.onSelect(this.currentDefinition)
      }, this))

      $('#editor-area').on('dblclick', '.definitions li', $.proxy(function(e) {
        e.stopPropagation()
        this.o.onChange(this.currentDefinition)
      }, this))
    },

    handleBlur: function() {
      $(document).click($.proxy(function(e) {
        if (this.currentDefinition != null) {
          this.currentDefinition.removeClass('active')
        }

        this.o.onBlur(this.currentDefinition)
      }, this))
    },

    current: function() {
      return {
        id      : this.currentDefinition.data('id'),
        text    : this.currentDefinition.html(),
        word_id : this.currentDefinition.data('word-id'),
        word    : this.currentDefinition.data('word')
      }
    },

    reset: function() {
      this.currentDefinition.removeClass('active').addClass('inactive')

      // Make same definitions inactive in all listings
      this.inactivateDefinitions(this.currentDefinition.data('id'))
      this.currentDefinition = null
    },

    resetInactive: function() {
      this.o.lists.find('li.inactive').removeClass('inactive')
    },

    resetInactiveDefinition: function(definitionId) {
      this.o.lists.find('li[data-id=' + definitionId + ']').removeClass('inactive')      
    },

    inactivateDefinitions: function(definitionIds) {
      if (!(definitionIds instanceof Array)) definitionIds = [definitionIds]

      $.each(definitionIds, $.proxy(function(index, definitionId) {
        this.o.lists.find('li[data-id=' + definitionId + ']').addClass('inactive')
      }, this))
    },

    clear: function() {
      this.o.lists.find('li.active').removeClass('active')
      this.currentDefinition = null
    }
  }
})(jQuery);
