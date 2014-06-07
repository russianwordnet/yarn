(function( $ ) {
  $.fn.EditorCurrentSynset = function(o) {
    var o = $.extend({
      template                : $('#current-synset-tpl').text(),
      wordTemplate            : $('#word-tpl').text(),
      definitionTemplate      : $('#definition-tpl').text(),
      defaultDefitionTemplate : $('#default-definition-tpl').text(),
      sampleTemplate          : $('#sample-tpl').text(),
      marksPicker             : $.fn.MarksPicker,
      onRemoveDefinition      : function(definitionId) {},
      onRemoveSample          : function(sampleId) {},
      onAfterRender           : function(data) {},
      onExpandAccordion       : function(accordion) { },
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorCurrentSynset.prototype = {
    currentSynsetId     : null,
    currentSynset       : null,
    selectedWords       : [],
    displayed           : false,

    initialize: function(o) {
      this.o = o
      this.handleAddCustomSample()
      this.handleAddSampleRuscorpora()
    },

    render: function(data) {
      this.remove()
      $('#current-synset').off('click')

      this.displayed           = true
      this.selectedWords       = data.words

      var currentWord = this.currentWord

      var accordionView = {
        hasSamples         : function() { return this.samples.length > 0 },
        hasDefinitions     : function() { return this.definitions.length > 0 },
        currentWord        : function() { return this.id == currentWord },
        default_definition : data.default_definition,
        words              : data.words,
        allow_destroy      : data.allow_destroy,
        allow_approve      : data.allow_approve
      }

      this.currentSynset = $(Mustache.render(this.o.template, accordionView, {
        word:               this.o.wordTemplate,
        definition:         this.o.definitionTemplate,
        default_definition: this.o.defaultDefitionTemplate,
        sample:             this.o.sampleTemplate
      }))
      this.accordions = this.currentSynset.find('.accordion')
      this.currentSynsetId = data.id
      this.default_definition = data.default_definition
      this.timestamp = data.timestamp

      $('#synsets').append(this.currentSynset)

      this.handleRemoveWord()
      this.handleRemoveDefinition()
      this.handleRemoveSample()
      this.handleSetDefaultDefinition()
      this.handleEditSynsetDefinition()
      this.handleSetDefaultSynsetWord()
      this.handleEditMarksBtn()
      this.handleDeleteButton()
      this.handleApproveButton()

      this.o.onAfterRender(data)

      this.accordions
        .on('show', $.proxy(function(e) { this.toggleIcon(e); this.setCurrentWord(e) }, this))
        .on('hide', $.proxy(function(e) { this.toggleIcon(e); this.clearCurrentWord(e) }, this))
        .on('shown', $.proxy(this.fireOnExpandAccordion, this))
        .on('hidden', $.proxy(this.fireOnExpandAccordion, this))
    },

    remove: function() {
      $('#current-synset').remove()
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

    handleAddSampleRuscorpora: function() {
      var modal = $('#add-example-external-corpora-modal')

      $(document).on('click', '#synset-word-add-sample-ruscorpora', function() {
        var synset_word_id = $(this).data('id')
        var synset_word = $(this).data('word')

        $.getJSON('/editor/ruscorpora_examples.json', {text: synset_word}, function(data) {
          var rendered_samples = $(Mustache.render($('#ruscorpora-sample-tpl').text(), {samples: data}, {}))
          modal.find('#external-corpora-examples').append(rendered_samples)
        })

        modal.find('[name=synset_word_id]').val(synset_word_id)
        modal.find('#add-example-modal-label').text('Добавление определения из НКРЯ')
      })

      $(document).on('click', '#synset-word-add-sample-opencorpora', function() {
        var synset_word_id = $(this).data('id')
        var synset_word = $(this).data('word')

        $.getJSON('/editor/opencorpora_examples.json', {text: synset_word}, function(data) {
          var rendered_samples = $(Mustache.render($('#ruscorpora-sample-tpl').text(), {samples: data}, {}))
          modal.find('#external-corpora-examples').append(rendered_samples)
        })

        modal.find('[name=synset_word_id]').val(synset_word_id)
        modal.find('#add-example-modal-label').text('Добавление определения из OpenCorpora')
      })

      // Reset modal form
      modal.on('hidden', function() {
        modal.find('#external-corpora-examples').empty()
      })

      modal.on('click', 'ul > li', $.proxy(function(e) {
        e.stopPropagation()
        var target = $(e.currentTarget)

        if (target.hasClass('active')) {
          target.removeClass('active')
          modal.find('#add-example').attr('disabled', 'disabled')
        } else {
          modal.find('.active').removeClass('active')
          target.addClass('active')
          modal.find('#add-example').removeAttr('disabled')
        }
      }, this))

      modal.find('#add-example').off().click($.proxy(function() {
        var current_sample = modal.find('.active').first()
        var params = {
          sample : {
            text    : current_sample.find(".sample-text").text(),
            source  : current_sample.find(".sample-source").text()
          },
          synset_word_id  : modal.find('[name=synset_word_id]').val()
        }

        // Add new definition
        $.post('/editor/create_sample.json', params, $.proxy(function(data) {
          this.timestamp = data.timestamp

          this.addSample(data, params.synset_word_id)

          modal.modal('hide')
        }, this))

      }, this))
    },

    handleEditSynsetDefinition: function() {
      var modal = $('#edit-definition-modal')
      var form    = modal.find('form')

      $(document).on('click', '#default-definition i.icon-pencil', $.proxy(function() {
        if (this.default_definition) {
          form.find('[name=text]').val(this.default_definition.text)
          form.find('[name=source]').val(this.default_definition.source)
          form.find('[name=uri]').val(this.default_definition.uri)
        }

        modal.modal()
      }, this))

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

        var definition = $(e.currentTarget).serializeObject()

        params = {
          id         : this.currentSynsetId,
          definition : definition
        }

        $.post('/editor/update_definition.json', params, $.proxy(function(data) {
          this.timestamp = data.timestamp
          this.default_definition = definition

          var defaultDefinition = $(Mustache.render(this.o.defaultDefitionTemplate, definition))
          $('#default-definition').html(defaultDefinition)

          modal.modal('hide')
        }, this))
      }, this))

      // Submit form on click on dialog primary button
      modal.find('button.btn-primary').off().click(function() {
        form.submit()
      })
    },

    addWord: function(word, save) {
      if (save == undefined) { save = true }
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
      if (save) { this.save() }
    },

    handleRemoveWord: function() {
      this.currentSynset.off('click', '.synset_word i.icon-remove').on('click', '.synset_word i.icon-remove', $.proxy(function(e) {
        if (this.selectedWords.length == 1) { return }
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
        }, this))
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

    addSample: function(sample, synset_word_id, save) {
      if (save == undefined) { save = true }

      var synset_word = $.grep(this.selectedWords, function(obj, i) { return obj.synset_word_id == synset_word_id }).pop()
      if ($.grep(synset_word.samples, function(obj, i) { return obj.id == sample.id }).length) { return }

      synset_word.samples.push(sample)

      var newSample = $(Mustache.render(this.o.sampleTemplate, sample))

      $('#content-collapse-' + synset_word_id + ' ol#samples').append(newSample)
      this.handleRemoveSample()

      if (save) { this.save() }
    },

    addDefinition: function(definition, synset_word_id) {
      this.addWord({ id : definition.word_id, word : definition.word }, false)

      var synset_word = this.findSynsetWord(synset_word_id, definition.word_id)
      if (synset_word == undefined) { return }

      if (definition.samples != undefined && definition.samples.length > 0) {
        $.map(definition.samples, $.proxy(function(sample) {
          return this.addSample(sample, synset_word.synset_word_id, false)
        }, this))
      }

      delete definition.samples

      if (!$.grep(synset_word.definitions, function(obj, i) { return obj.id == definition.id }).length) {
        synset_word.definitions.push(definition)
        var newDefinition = $(Mustache.render(this.o.definitionTemplate, definition))

        $('#content-collapse-' + synset_word.id + ' ol#synset-definitions').append(newDefinition)
        this.handleRemoveDefinition()
      }

      this.save()
    },

    findSynsetWord: function(synset_word_id, word_id) {
      if(synset_word_id != undefined)
        return $.grep(this.selectedWords, function(obj, i) { return obj.synset_word_id == synset_word_id }).pop()
      else
        return $.grep(this.selectedWords, function(obj, i) { return obj.id == word_id }).pop()
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

    handleSetDefaultDefinition: function() {
      this.currentSynset.find('#synset-definitions i.icon-flag').off('click', '**').click($.proxy(function(e) {
        var definition_id = $(e.currentTarget).closest('li').data('id')

        this.default_definition = {id: definition_id}
        this.save()
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
        definition      : this.default_definition,
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
      var icon = $(e.target).closest('.accordion-group').find('a > i.icon-collapse')
      if (icon.hasClass('icon-caret-right')) {
        icon.removeClass('icon-caret-right').addClass('icon-caret-down')
      } else {
        icon.removeClass('icon-caret-down').addClass('icon-caret-right')
      }
    },

    setCurrentWord: function(e) {
      var id = $(e.target).closest('.accordion-group').find('.accordion-toggle').data('id')

      this.currentWord = id
    },

    clearCurrentWord: function(e) {
      this.currentWord = null
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
