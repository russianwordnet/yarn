(function( $ ) {
  $.fn.EditorCurrentSynset = function(iframe, o) {
    var o = $.extend({
      onDataLoad: function(data) {},
    }, o)

    this.initialize(word, data, o)
  }
  
  $.fn.EditorCurrentSynset.prototype = {
    iframe : null,
    el     : null,

    initialize: function(word, data, o) {
      this.build()
    },

    // Build Toolbar object
    build: function() {

    }
  }
})(jQuery);
