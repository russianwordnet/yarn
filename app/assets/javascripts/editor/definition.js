(function( $ ) {
  $.fn.EditorDefinition = function(o) {
    var o = $.extend({
      lists         : $('#editor-area .definitions'),
      current       : $('.definitions ul > li.active'),
      onSelect      : function(definition) {},
      onChange      : function(definition) {},
      onBlur        : function(definition) {},
      onAdd         : function(definition) {}
    }, o)

    this.initialize(o)
  }

  $.fn.EditorDefinition.prototype = {
    currentDefinition : null,

    initialize: function(o) {
      this.o = o
      this.currentDefinition = this.o.current
      this.handleLists()
      this.handleHideButtons()
      this.handleExpandHiddenButton()
      this.handleAddButtons()
      this.handleBlur()
    },

    handleLists: function() {
      $('#editor-area').on('click', '.definitions > ul > li', $.proxy(function(e) {
        e.stopPropagation()

        this.setCurrent($(e.currentTarget))
      }, this))

      $('#editor-area').on('dblclick', '.definitions ul > li', $.proxy(function(e) {
        e.stopPropagation()
        this.o.onChange(this.currentDefinition)
      }, this))
    },

    handleHideButtons: function() {
      $('#editor-area').on('click', '.definitions ul > li i.icon.icon-eye-close', $.proxy(function(e) {
        $(e.target).closest('li').addClass('hide')
        $('#expand-hidden').show()
      }, this))
    },

    handleExpandHiddenButton: function() {
      $('#expand-hidden').on('click', $.proxy(function(e) {
        $('#editor-area .definitions ul > li.hide').removeClass('hide')
        $(e.currentTarget).hide()
      }, this))
    },

    handleAddButtons: function () {
      $('#editor-area').on('click', '.definitions ul > li i.icon.icon-plus', $.proxy(function(e) {
        this.setCurrent($(e.currentTarget).closest('li'))
        this.o.onAdd(this.current())
      }, this))
    },

    handleBlur: function() {
      $(document).click($.proxy(function(e) {
        if (this.currentDefinition != null) {
          this.currentDefinition.removeClass('active')
        }

        this.o.onBlur(this.currentDefinition)
      }, this))
    },

    current: function() {
      return {
        id      : this.currentDefinition.data('id'),
        text    : this.currentDefinition.find('.content').html(),
        word_id : this.currentDefinition.data('word-id'),
        word    : this.currentDefinition.data('word'),
        samples : $.map(this.currentDefinition.find('.sample li'), function(obj) {
          return {id: $(obj).data('id'), text: $(obj).text()}
        })
      }
    },

    reset: function() {
      this.currentDefinition.removeClass('active').addClass('inactive')

      // Make same definitions inactive in all listings
      this.inactivateDefinitions(this.currentDefinition.data('id'))
      this.currentDefinition = null
    },

    resetInactive: function() {
      this.o.lists.find('li.inactive').removeClass('inactive')
    },

    resetInactiveDefinition: function(definitionId) {
      this.o.lists.find('li[data-id=' + definitionId + ']').removeClass('inactive')
    },

    inactivateDefinitions: function(definitionIds) {
      if (!(definitionIds instanceof Array)) definitionIds = [definitionIds]

      $.each(definitionIds, $.proxy(function(index, definitionId) {
        this.o.lists.find('li[data-id=' + definitionId + ']').addClass('inactive')
      }, this))
    },

    clear: function() {
      this.o.lists.find('li.active').removeClass('active')
      this.currentDefinition = null
    },

    setCurrent: function(definition) {
      if (this.currentDefinition != null) {
          this.currentDefinition.removeClass('active')
        }

        this.currentDefinition = definition.addClass('active')
        this.o.onSelect(this.currentDefinition)
    }
  }
})(jQuery);
