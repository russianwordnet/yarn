(function( $ ) {
  $.fn.EditorAddToCurrentSynsetButton = function(o) {
    var o = $.extend({
      selector  : $('#add-to-current-synset-btn'),
      column    : $('#right-column'),
      onClick   : function() {},
      onBtnOver : function(e) {},
      onBtnOut  : function(e) {}
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorAddToCurrentSynsetButton.prototype = {
    enabled : false,

    initialize: function(o) {
      this.o = o

      this.o.selector.off('click').click($.proxy(function(e) {
        if (this.isEnabled()) {
          e.stopPropagation()
          this.o.onClick()
          this.disable()
        }
      }, this)).hover(
        $.proxy(function(e) { if (this.isEnabled()) this.o.onBtnOver(e) }, this),
        $.proxy(function(e) { if (this.isEnabled()) this.o.onBtnOut(e) }, this)
      )
    },

    enable: function() {
      this.enabled = true
      this.o.selector.removeClass('disabled')
    },

    disable: function() {
      this.enabled = false
      this.o.selector.addClass('disabled')
    },

    adjustHeight: function() {
      if (this.o.column) {
        this.o.selector.css('height', this.o.column.height())
      }
    },

    isEnabled: function() {
      return this.enabled
    }
  }
})(jQuery);
