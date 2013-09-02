(function( $ ) {
  $.fn.EditorSynsets = function(data, o) {
    var o = $.extend({
      placeholder : $('#synsets-placeholder'),
      template    : $('#synsets-tpl').text()
    }, o)

    this.initialize(data, o)
  }
  
  $.fn.EditorSynsets.prototype = {
    data : null,

    initialize: function(data, o) {
      this.data = data
      this.o    = o
      this.render()
    },

    render: function() {
      this.o.placeholder.html(
        Mustache.render(this.o.template, { synsets: this.data.synsets })
      )
    },

    handle: function() {
      
    }
  }
})(jQuery);
