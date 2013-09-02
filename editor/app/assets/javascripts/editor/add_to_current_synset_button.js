(function( $ ) {
  $.fn.EditorAddToCurrentSynsetButton = function(o) {
    var o = $.extend({
      selector : $('#add-to-current-synset-btn'),
      column   : $('#right-column'),
      onClick  : function() {}
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorAddToCurrentSynsetButton.prototype = {
    enabled : false,

    initialize: function(o) {
      this.o = o

      this.o.selector.click($.proxy(function(e) {
        if (this.isEnabled()) {
          e.stopPropagation()
          this.o.onClick()
        }
      }, this))
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
/*

    click: function() {
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
    }
    */
  }
})(jQuery);
