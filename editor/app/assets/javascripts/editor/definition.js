(function( $ ) {
  $.fn.EditorDefinition = function(o) {
    var o = $.extend({
      lists         : $('.definitions'),
      current       : $('.definitions li.active'),
      onSelect      : function(definition) {},
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
      this.o.lists.on('click', 'li', $.proxy(function(e) {
        e.stopPropagation()

        if (this.currentDefinition != null) {
          this.currentDefinition.removeClass('active')
        }

        this.currentDefinition = $(e.currentTarget).addClass('active')
        this.o.onSelect(this.currentDefinition)
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
    }
  }
})(jQuery);
