(function( $ ) {
  $.fn.EditorDefinitions = function(data, o) {
    var o = $.extend({
      placeholder   : $('#word-definitions-placeholder'),
      template      : $('#listing-tpl').text(),
      onAfterRender : function() {}
    }, o)

    this.initialize(data, o)
  }
  
  $.fn.EditorDefinitions.prototype = {
    data : null,

    initialize: function(data, o) {
      this.data = data
      this.o    = o
      this.render()
      this.o.onAfterRender()
    },

    render: function() {
      var hasSamples = function() { return this.samples != null }
      this.o.placeholder.html(
        Mustache.render(this.o.template, { definitions: this.data.definitions, hasSamples: hasSamples })
      )
    }
  }
})(jQuery);
