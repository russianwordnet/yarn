(function( $ ) {
  $.fn.WordPicker = function(el, o) {
    var o = $.extend({
      asSynonymPicker : false,
      allowClose      : true,
      onSelectWord    : function(word, wordId) {},
      onPickWord      : function(word, wordId) {}
    }, o)

    this.initialize(el, o)
  }

  $.fn.WordPicker.prototype = {
    currentWord: null,
    currentWordId: null,

    initialize: function(el, o) {
      this.el = $(el)
      this.o  = o
      this.content = this.el.find('.word-picker-content')
      this.lock = false

      this.content.on('click', '.pagination a', $.proxy(function(e) {
        e.preventDefault()

        $.get($(e.currentTarget).attr('href'), $.proxy(function(data) {
          this.content.html(data)
        }, this))
      }, this))

      this.handleSeachForm()
      this.handleSeachInput()
      this.handleListing()
      this.disallowClose()
    },

    disallowClose: function() {
      if (!this.o.allowClose) {
        this.el.find('[data-dismiss=modal]').hide()
        this.el.modal({
          backdrop: 'static',
          keyboard: false
        })
      } else {
        this.el.find('[data-dismiss=modal]').show()
        this.el.modal({
          backdrop: true,
          keyboard: true
        })
      }
    },

    handleSeachForm: function() {
      this.el.find('form').on('submit', function(e) {
        e.preventDefault()
      })
    },

    handleSeachInput: function() {
      var input = this.el.find('input.search-query')

      input.on('keyup', $.proxy(function(e) {
        var code = (e.keyCode ? e.keyCode : e.which)

        if (code != 13 && !this.lock) {
          this.lock = true
          $.get('/editor', { word : input.val() }, $.proxy(function(data) {
            this.content.html(data)
            this.currentWord   = null
            this.currentWordId = null
            this.lock = false
          }, this))
        }
      }, this))
    },

    handleListing: function() {
      this.content.on('click', '.word-picker-listing li', $.proxy(function(e) {
        e.stopPropagation()

        if (this.currentWord != null) {
          this.currentWord.removeClass('active')
        }

        this.currentWord   = $(e.currentTarget).addClass('active')
        this.currentWordId = this.currentWord.data('id')

        this.o.onSelectWord(this.currentWord, this.currentWordId)
      }, this))

      this.content.on('dblclick', '.word-picker-listing li', $.proxy(function(e) {
        e.stopPropagation()

        if (this.currentWord) {
          this.o.onPickWord(this.currentWord, this.currentWordId)
          this.el.modal('hide')
        }
      }, this))
    },

    show: function() {
      this.el.modal('show')
    }

  }
})(jQuery);
