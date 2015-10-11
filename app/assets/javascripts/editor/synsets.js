(function( $ ) {
  $.fn.EditorSynsets = function(data, o) {
    var o = $.extend({
      placeholder : $('#synsets-placeholder'),
      template    : $('#synsets-tpl').text(),
      selectedSynsetTemplate : $('#selected-synset-tpl').text(),
      onAdd       : function(data, synset) {},
      onSelect    : function(synsetId) {},
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

      $("#current-synset").empty()
      this.render(data)
      this.handleAdd()
      this.handleMerge()
    },

    render: function(data) {
      this.synsets = $(Mustache.render(this.o.template, { synsets: data.synsets }))
      this.o.placeholder.html(this.synsets)
      this.handleList()
    },

    handleAdd: function() {
      $('#synsets section:first-child').off('click', '**').on('click', 'a', $.proxy(function(e) {
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

    handleMerge: function() {
      this.synsets.find('i').off('click').on('click', $.proxy(function(event) {
        event.stopPropagation()

        if(!confirm("Вы точно хотите слить данный синсет с выбранным?")) { return false }
        $.post('/synsets/merge.json',
          {
            acceptor_synset_id: this.selectedSynset.data('id'),
            synset_id: $(event.currentTarget).closest('li').data('id')
          }
        ).success($.proxy(function(data, status, xhr) {
          $(event.currentTarget).closest('li').remove();
          //this.updateSelected(data)
          this.o.onSelect(data['id'])
        }, this))
      }, this))
    },

    handleList: function() {
      this.selectedSynset = this.synsets.find('li.active')

      this.synsets.find('ul').off('click', '**').on('click', 'li.normal', $.proxy(function(e) {
        e.stopPropagation()

        this.synsets.find('i').show()

        if (this.selectedSynset != null) {
          this.selectedSynset.removeClass('active')
        }

        this.selectedSynset = $(e.currentTarget).addClass('active')
        $(e.currentTarget).find('i').hide()

        this.o.onSelect(this.selectedSynset.data('id'))
      }, this))
    },

    setSelected: function(id) {
      this.selectedSynset = this.synsets.find('[data-id=' + id + ']')
      this.selectedSynset.addClass('active')
    },

    // Тут короче фишка в том, что мы заменяем текущий выделенный синсет на шаблон и поэтому на него пропадает ссылка this.selectedSynset
    // Надо чето придумать
    updateSelected: function(data) {
      this.selectedSynset.html(
        $(Mustache.render(this.o.selectedSynsetTemplate, data))
      )
      this.handleMerge()
    }
  }
})(jQuery);
