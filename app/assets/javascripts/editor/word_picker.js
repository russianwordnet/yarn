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
      this.searching = 0

      this.content.on('click', '.pagination a', $.proxy(function(e) {
        e.preventDefault()
        
        $.get($(e.currentTarget).attr('href'), $.proxy(function(data) {
          this.content.html(data)
        }, this))
      }, this))

      this.handleSeachForm()
      this.handleSeachInput()
      this.handleListing()
      this.handlePrimaryBtn()
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
        if (this.searching) {
            clearTimeout(this.searching);
        }
        searching = setTimeout($.proxy(function() {
          var code = (e.keyCode ? e.keyCode : e.which)

          if (code != 13) {
            $.get('/editor', { word : input.val() }, $.proxy(function(data) {
              this.content.html(data)
              this.currentWord   = null
              this.currentWordId = null
              this.togglePrimaryBtn()
            }, this))
          }
        }, this), 150)
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

        this.togglePrimaryBtn()
        this.o.onSelectWord(this.currentWord, this.currentWordId)
      }, this))

      this.content.on('dblclick', '.word-picker-listing li', $.proxy(function(e) {
        e.stopPropagation()
        this.el.find('.btn-primary').trigger('click')
      }, this))      
    },

    togglePrimaryBtn: function() {
      var btn = this.el.find('.btn-primary')

      if (this.currentWord == null) {
        btn.addClass('disabled')
      } else {
        btn.removeClass('disabled')
      }
    },

    handlePrimaryBtn: function() {
      this.el.find('.btn-primary').on('click', $.proxy(function() {
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
