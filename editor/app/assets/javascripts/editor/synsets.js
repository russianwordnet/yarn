(function( $ ) {
  $.fn.EditorSynsets = function(data, o) {
    var o = $.extend({
      placeholder : $('#synsets-placeholder'),
      template    : $('#synsets-tpl').text(),
      onAdd       : function(newSynset) {},
      onSelect    : function() {},
    }, o)

    this.initialize(data, o)
  }
  
  $.fn.EditorSynsets.prototype = {
    synsets : null,
    wordId  : null,

    initialize: function(data, o) {
      this.o = o
      this.wordId = data.id

      this.render(data)
      this.handleAdd()
    },

    render: function(data) {
      this.synsets = $(Mustache.render(this.o.template, { synsets: data.synsets }))
      this.o.placeholder.html(this.synsets)
    },

    handleAdd: function() {
      $('#synsets').find('a').click($.proxy(function(e) {
        e.preventDefault()

        $.post('/editor/create_synset', { word_id: this.wordId }, $.proxy(function(data) {
          this.render(data)
          this.handleList()

          // Highligth new synset
          var synsetsWrapper = this.synsets.find('ul').closest('div')
          var newSynset = this.synsets.find('li[data-id="' + data.id + '"]').addClass('active')
          
          synsetsWrapper[0].scrollTop = synsetsWrapper[0].scrollHeight
          this.o.onAdd(data, newSynset)
        }, this))
      }, this))
    },

    handleList: function() {
      selectedSynset = this.synsets.find('li.active')
      
      this.synsets.find('ul').on('click', 'li', $.proxy(function(e) {
        e.stopPropagation()

        if (selectedSynset != null) {
          selectedSynset.removeClass('active')
        }

        selectedSynset = $(e.currentTarget).addClass('active')
      }, this))
    }
  }
})(jQuery);
