(function( $ ) {
  $.fn.EditorCurrentSynset = function(o) {
    var o = $.extend({
      template           : $('#current-synset-tpl').text(),
      wordTemplate       : $('#word-tpl').text(),
      definitionTemplate : $('#definition-tpl').text(),
      marksPicker        : $.fn.MarksPicker,
      onRemoveDefinition : function(definitionId) {},
      onRemoveSample     : function(sampleId) {},
      onAfterRender      : function(data) {},
      onExpandAccordion  : function(accordion) { },
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
      this.handleAddCustomSample()
    },

    render: function(data) {
      this.remove()
      $('#current-synset').off('click')

      this.displayed           = true
      this.selectedDefinitions = data.definitions
      this.selectedWords       = data.words

      var accordionView = {
        hasSamples     : function() { return this.samples.length > 0 },
        hasDefinitions : function() { return this.definitions.length > 0 },
        definitions    : data.definitions,
        words          : data.words,
        allow_destroy  : data.allow_destroy,
        allow_approve  : data.allow_approve
      }

      this.currentSynset       = $(Mustache.render(this.o.template, accordionView, {
        word:       this.o.wordTemplate,
        definition: this.o.definitionTemplate
      }))
      this.accordions = this.currentSynset.find('.accordion')
      this.currentSynsetId     = data.id
      this.timestamp = data.timestamp

      $('#synsets').append(this.currentSynset)

      this.handleRemoveWord()
      this.handleRemoveDefinition()
      this.handleRemoveSample()
      this.handleCloneDefinition()
      this.handleSetDefaultDefinition()
      this.handleSetDefaultSynsetWord()
      this.handleEditMarksBtn()
      this.handleDeleteButton()
      this.handleApproveButton()

      this.o.onAfterRender(data)

      this.accordions
        .on('show', this.toggleIcon)
        .on('hide', this.toggleIcon)
        .on('shown', $.proxy(this.fireOnExpandAccordion, this))
        .on('hidden', $.proxy(this.fireOnExpandAccordion, this))
    },

    remove: function() {
      $('#current-synset').remove()
    },

    handleAddCustomDefinition: function() {
      var modal = $('#add-definition-modal')
      var form    = modal.find('form')

      $(document).on('click', '#synset-word-add-definition', function() {
        var synset_word_id = $(this).data('id')

        modal.find('[name=synset_word_id]').val(synset_word_id)
      })

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
          definition      : $(e.currentTarget).serializeObject(),
          synset_id       : this.currentSynsetId,
          synset_word_id  : $(e.currentTarget).siblings('[name=synset_word_id]').val()
        }

        // Add new definition
        $.post('/editor/create_definition.json', params, $.proxy(function(data) {
          this.timestamp = data.timestamp

          if(params.synset_word_id.length) {
            this.addDefinition(data, params.synset_word_id)
          }
          else {
            this.addDefinitionToSynset(data)
          }

          modal.modal('hide')
        }, this))
      }, this))

      // Submit form on click on dialog primary button
      modal.find('button.btn-primary').off().click(function() {
        form.submit()
      })
    },

    handleAddCustomSample: function() {
      var modal = $('#add-sample-modal')
      var form  = modal.find('form')

      $(document).on('click', '#synset-word-add-sample', function() {
        var synset_word_id = $(this).data('id')

        modal.find('[name=synset_word_id]').val(synset_word_id)
      })

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
          sample          : $(e.currentTarget).serializeObject(),
          synset_word_id  : $(e.currentTarget).siblings('[name=synset_word_id]').val()
        }

        // Add new definition
        $.post('/editor/create_sample.json', params, $.proxy(function(data) {
          this.timestamp = data.timestamp

          this.addSample(data, params.synset_word_id)

          modal.modal('hide')
        }, this))
      }, this))

      // Submit form on click on dialog primary button
      modal.find('button.btn-primary').off().click(function() {
        form.submit()
      })
    },

    addWord: function(word) {
      if(word.id == undefined || word.word == undefined) { return }
      // Do not add new word if already exists
      if ($.grep(this.selectedWords, function(obj, i) { return obj.id == word.id }).length) {
        return
      }
      // Add new word
      word.samples = []
      word.definitions = []
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

    addDefinitionToSynset: function(definition) {
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

    addSample: function(sample, synset_word_id) {
      var synset_word = $.grep(this.selectedWords, function(obj, i) { return obj.synset_word_id == synset_word_id }).pop()

      if (synset_word == undefined) { return }
      if ($.grep(synset_word.samples, function(obj, i) { return obj.id == sample.id }).length) { return }

      synset_word.samples.push(sample)

      var newSample = $(Mustache.render(this.o.definitionTemplate, sample))

      $('#content-collapse-' + synset_word_id + ' ol#samples').append(newSample)
      this.handleRemoveSample()
      this.save()
    },

    addDefinition: function(definition, synset_word_id) {
      var synset_word

      this.addWord({ id : definition.word_id, word : definition.word })

      if(synset_word_id != undefined)
        synset_word = $.grep(this.selectedWords, function(obj, i) { return obj.synset_word_id == synset_word_id }).pop()
      else
        synset_word = $.grep(this.selectedWords, function(obj, i) { return obj.id == definition.word_id }).pop()

      if (synset_word == undefined) { return }
      if ($.grep(synset_word.definitions, function(obj, i) { return obj.id == definition.id }).length) { return }

      synset_word.definitions.push(definition)

      var newDefinition = $(Mustache.render(this.o.definitionTemplate, definition))

      $('#content-collapse-' + synset_word.id + ' ol#synset-definitions').append(newDefinition)
      this.handleRemoveDefinition()
      this.save()
    },

    handleRemoveDefinition: function() {
      this.currentSynset.find('ol#synset-definitions .icon-remove').off('click', '**').click($.proxy(function(e) {
        var item = $(e.currentTarget).closest('li'),
            word_id = item.closest('.accordion-body').data('id'),
            synset_word = $.grep(this.selectedWords, function(obj) { return obj.id == word_id }).pop()

        synset_word.definitions = $.grep(synset_word.definitions, function(obj) {
          return obj.id != item.data('id')
        })

        this.o.onRemoveDefinition(item.data('id'))
        item.remove()
        this.save()
      }, this))
    },

    handleRemoveSample: function() {
      this.currentSynset.find('ol#synset-samples .icon-remove').off('click', '**').click($.proxy(function(e) {
        var item = $(e.currentTarget).closest('li'),
            word_id = item.closest('.accordion-body').data('id'),
            synset_word = $.grep(this.selectedWords, function(obj) { return obj.id == word_id }).pop()

        synset_word.samples = $.grep(synset_word.samples, function(obj) {
          return obj.id != item.data('id')
        })

        this.o.onRemoveSample(item.data('id'))
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
      return true
    },

    save: function() {
      if (!this.isValid()) return

      var params = {
        _method         : 'put',
        synset_id       : this.currentSynsetId,
        lexemes         : this.wordIds(),
        timestamp       : this.timestamp
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

    wordIds: function() {
      return $.map(this.selectedWords, function(n, i) {
        return {
          id: n.id,
          definitions: $.map(n.definitions, function(d, i) { return d.id }),
          samples:     $.map(n.samples, function(d, i) { return d.id })
        }
      })
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
        selected_ids: this.marksIds(parent),
        timestamp: this.timestamp
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
    },

    toggleIcon: function(e) {
      var icon = $(e.target).closest('.accordion-heading').find('a > i.icon-collapse')
      if (icon.hasClass('icon-caret-right')) {
        icon.removeClass('icon-caret-right').addClass('icon-caret-down')
      } else {
        icon.removeClass('icon-caret-down').addClass('icon-caret-right')
      }
    },

    fireOnExpandAccordion: function() {
      this.o.onExpandAccordion(this.currentSynset)
    },

    handleDeleteButton: function() {
      $(document).off('click', '#destroy-current-synset').on('click', '#destroy-current-synset', $.proxy(function(e) {
        e.preventDefault()

        var url = '/synsets/' + this.currentSynsetId + '.json'

        if (confirm('Вы уверены, что хотите удалить синсет?')) {
          $.post(url, {_method : 'delete'}, function() {
            location.reload()
          })
        }
      }, this))
    },

    handleApproveButton: function() {
      $(document).off('click', '#approve-current-synset').on('click', '#approve-current-synset', $.proxy(function(e) {
        e.preventDefault()

        var url = '/synsets/' + this.currentSynsetId + '/approve'

        if (confirm('Вы уверены, что хотите подтвердить синсет?')) {
          $.get(url, function() {
            location.reload()
          })
        }
      }, this))
    }
}
})(jQuery);
