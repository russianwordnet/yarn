(function( $ ) {
  $.fn.EditorSynsets = function(data, o) {
    var o = $.extend({
      placeholder : $('#synsets-placeholder'),
      template    : $('#synsets-tpl').text(),
      onAdd       : function(data, synset) {},
      onSelect    : function(data, synset) {},
    }, o)

    this.initialize(data, o)
  }
  
  $.fn.EditorSynsets.prototype = {
    synsets        : null,
    wordId         : null,
    selectedSynset : null,

    initialize: function(data, o) {
      this.o = o
      this.wordId = data.id

      this.render(data)
    },

    render: function(data) {
      this.synsets = $(Mustache.render(this.o.template, { synsets: data.synsets }))
      this.o.placeholder.html(this.synsets)
      this.handleAdd()
      this.handleList()
    },

    handleAdd: function() {
      $('#synsets').find('a').click($.proxy(function(e) {
        e.preventDefault()

        $.post('/editor/create_synset.json', { word_id: this.wordId }, $.proxy(function(data) {
          this.render(data)

          // Highligth new synset
          var synsetsWrapper  = this.synsets.find('ul').closest('div')
          this.selectedSynset = this.synsets.find('li[data-id="' + data.id + '"]').addClass('active')
          
          synsetsWrapper[0].scrollTop = synsetsWrapper[0].scrollHeight
          this.o.onAdd(data, this.selectedSynset)
        }, this))
      }, this))
    },

    handleList: function() {
      this.selectedSynset = this.synsets.find('li.active')
      
      this.synsets.find('ul').on('click', 'li', $.proxy(function(e) {
        e.stopPropagation()

        if (this.selectedSynset != null) {
          this.selectedSynset.removeClass('active')
        }

        this.selectedSynset = $(e.currentTarget).addClass('active')

        $.getJSON('/synsets/' + this.selectedSynset.data('id') + '.json', $.proxy(function(data) {
          this.o.onSelect(data, this.selectedSynset)
        }, this))
      }, this))
    }
  }
})(jQuery);
