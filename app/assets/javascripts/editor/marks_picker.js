(function( $ ) {
  $.fn.MarksPicker = function(data, o) {
    var o = $.extend({
      dialog              : $('#select-marks-modal'),
      onAfterRender       : function() {},
      onAfterEditMarks    : function() {}
    }, o)

    this.initialize(data, o)
  }

  $.fn.MarksPicker.prototype = {
    data : null,

    initialize: function(data, o) {
      this.o    = o
      this.data = data
      this.render()
      this.o.onAfterRender()
      this.handlePickMark()
      this.handleClose()
    },

    handleClose: function() {
      this.o.dialog.off('hidden').on('hidden', $.proxy(function(e) {
        $.post('/editor/edit_marks',
          {
            synset_id:      this.data.synset_id,
            synset_word_id: this.data.id,
            marks:          this.selectedIds(),
            timestamp:      this.data.timestamp
          }, $.proxy(function(data) {
          this.o.onAfterEditMarks(data)
        }, this))

      }, this))
    },

    render: function() {
      this.o.dialog.find('.active').each(function(index, element) {
        $(element).removeClass('active')
      })

      $.each(this.data.selected_ids,
        $.proxy(function(i, id) {
          this.o.dialog.
               find('ul').
               find('[data-id = ' + id + ']').
               addClass('active')
        }, this)
      )
    },

    handlePickMark: function() {
      this.o.dialog.find('.mark').off('click').on('click', function(event) {
        event.preventDefault();

        $(event.currentTarget).siblings('.active').removeClass('active')
        $(event.currentTarget).toggleClass('active')
      })
    },

    show: function() {
      this.o.dialog.modal('show')
    },

    selectedIds: function() {
      var ids = this.o.dialog.find('.active').map(function(index, element) {
        return $(element).data('id')
      })

      return ids.get()
    }
  }
})(jQuery);