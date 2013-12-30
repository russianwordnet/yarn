(function( $ ) {
  $.fn.EditorCurrentSynset = function(o) {
    var o = $.extend({
      template           : $('#current-synset-tpl').text(),
      wordTemplate       : $('#word-tpl').text(),
      definitionTemplate : $('#definition-tpl').text(),
      marksPicker        : $.fn.MarksPicker,
      onRemoveDefinition : function(definitionId) {},
      onAfterRender      : function(data) {},
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorCurrentSynset.prototype = {
    currentSynsetId     : null,
    currentSynset       : null,
    selectedWords       : [],
    selectedDefinitions : [],
    displayed           : false,

    initialize: function(o) {
      this.o = o
      this.handleAddCustomDefinition()
    },

    render: function(data) {
      this.remove()
      $('#current-synset').off('click')

      this.displayed           = true
      this.selectedDefinitions = data.definitions
      this.selectedWords       = data.words
      this.currentSynset       = $(Mustache.render(this.o.template, data))
      this.currentSynsetId     = data.id

      $('#synsets').append(this.currentSynset)
      this.handleRemoveWord()
      this.handleRemoveDefinition()
      this.handleCloneDefinition()
      this.handleSetDefaultDefinition()
      this.handleSetDefaultSynsetWord()
      this.handleEditMarksBtn()
      this.o.onAfterRender(data)
    },

    remove: function() {
      $('#current-synset').remove()
    },

    handleAddCustomDefinition: function() {
      var modal = $('#add-definition-modal')
      var form  = $('#add-definition-form')

      // Reset modal form
      modal.on('hidden', function() {
        form[0].reset()
      })

      // Add validators and its callbacks
      form.validate({
        rules: {
          text: {
            required: true
          }
        },
        highlight: function(element) {
          $(element).closest('.control-group').removeClass('success').addClass('error');
        },
        success: function(element) {
          element.addClass('valid').closest('.control-group').removeClass('error')
        }
      })

      // What to do on submit
      form.off().on('submit', $.proxy(function(e) {
        e.preventDefault()
        if (!form.valid()) return

        var params = {
          definition : $(e.currentTarget).serializeObject(),
          synset_id  : this.currentSynsetId
        }

        // Add new definition
        $.post('/editor/create_definition.json', params, $.proxy(function(data) {
          this.addDefinition(data)
          modal.modal('hide')
        }, this))
      }, this))

      // Submit form on click on dialog primary button
      modal.find('button.btn-primary').off().click(function() {
        form.submit()
      })
    },

    addWord: function(word) {
      // Do not add new word if already exists
      if ($.grep(this.selectedWords, function(obj, i) { return obj.id == word.id }).length) {
        return
      }
      // Add new word
      this.selectedWords.push(word)

      var newWord = $(Mustache.render(this.o.wordTemplate, word))
        .css('background-color', '#38B2E5')
        .animate({
          backgroundColor: '#eeeeee',
        }, { duration: 700 })

      $('#synset-words').append(newWord)
      this.handleRemoveWord()
      this.save()
    },

    handleRemoveWord: function() {
      this.currentSynset.off('click', '.synset_word i.icon-remove').on('click', '.synset_word i.icon-remove', $.proxy(function(e) {
        var item = $(e.currentTarget).closest('a')

        this.selectedWords = $.grep(this.selectedWords, function(obj) {
          return obj.id != item.data('id')
        })

        item.remove()
        this.save()
      }, this))
    },

    handleSetDefaultSynsetWord: function() {
      this.currentSynset.off('click', '.synset_word i.icon-flag').on('click', '.synset_word i.icon-flag', $.proxy(function(e) {
        var item = $(e.currentTarget).closest('a')

        $.post('/editor/set_default_synset_word',
        {
          synset_id       : this.currentSynsetId,
          synset_word_id  : item.data('synset-word-id')
        },
        $.proxy( function(data) {
          this.render(data)
        }, this)
        )
      }, this))
    },

    highlightOn: function() {
      $('#current-synset').addClass('active')
    },

    highlightOff: function() {
      $('#current-synset').removeClass('active')
    },

    highlightWords: function() {
      $('#synset-words').toggleClass('active')
    },

    addDefinition: function(definition) {
      if ($.grep(this.selectedDefinitions, function(obj, i) { return obj.id == definition.id }).length) {
        return
      }

      this.selectedDefinitions.push(definition)

      if (definition.word) {
        this.addWord({ id :definition.word_id, word : definition.word })
      }

      var newDefinition = $(Mustache.render(this.o.definitionTemplate, definition))

      $('#current-synset ol').append(newDefinition)
      this.handleRemoveDefinition()
      this.save()
    },

    handleRemoveDefinition: function() {
      this.currentSynset.find('li .icon-remove').off('click', '**').click($.proxy(function(e) {
        var item = $(e.currentTarget).closest('li')

        this.selectedDefinitions = $.grep(this.selectedDefinitions, function(obj) {
          return obj.id != item.data('id')
        })

        this.o.onRemoveDefinition(item.data('id'))
        item.remove()
        this.save()
      }, this))
    },

    handleCloneDefinition: function() {
      this.currentSynset.find('li .icon-copy').off('click', '**').click($.proxy(function(e) {
        var definition = $(e.currentTarget).closest('li').find('span').text()
        $('#current-synset a.dashed-link').trigger('click')
        $('#add-definition-modal #inputText').val(definition)
      }, this))
    },

    handleSetDefaultDefinition: function() {
      this.currentSynset.find('li .icon-flag.definition').off('click', '**').click($.proxy(function(e) {
        var item = $(e.currentTarget).closest('li')

        $.post('/editor/set_default_definition',
        {
          synset_id     : this.currentSynsetId,
          definition_id : item.data('id')
        },
        $.proxy( function(data) {
          this.render(data)
        }, this)
        )
      }, this))
    },

    isDisplayed: function() {
      return this.displayed
    },

    isValid: function() {
      return this.selectedDefinitions.length > 0
    },

    save: function() {
      if (!this.isValid()) return

      var params = {
        _method         : 'put',
        synset_id       : this.currentSynsetId,
        definitions_ids : this.definitionIds(),
        lexemes_ids     : this.wordIds()
      }

      $.post('/editor/save.json', params, $.proxy(function(data) {
        this.render(data)
      }, this))
    },

    load: function(synsetId) {
      $.getJSON('/synsets/' + synsetId + '.json', $.proxy(function(data) {
        this.render(data)
      }, this))
    },

    definitionIds: function() {
      return $.map(this.selectedDefinitions, function(n, i) { return n.id })
    },

    wordIds: function() {
      return $.map(this.selectedWords, function(n, i) { return n.id })
    },

    handleEditMarksBtn: function() {
      $(document).off('click', '.edit-marks').on('click', '.edit-marks', $.proxy(function(e) {
        e.preventDefault()
        this.marksPickerDialog(e.target)
      }, this))
    },

    marksPickerDialog: function(target) {
      var parent = $(target).closest('a')
      var data = {
        id:   parent.data('synset-word-id'),
        synset_id: this.currentSynsetId,
        selected_ids: this.marksIds(parent)
      }

      this.marksPicker = new this.o.marksPicker(data, {
        onAfterEditMarks : $.proxy(function(edited_data) {
          this.render(edited_data)
        }, this), 
      })
      this.marksPicker.show()
    },

    marksIds: function(parent) {
      var ids = $(parent).find('.mark').map(function(index, element) {
          return $(element).data('id')
      })

      return ids.get()
    }
}
})(jQuery);
