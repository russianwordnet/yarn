(function( $ ) {
  $.fn.EditorCurrentSynset = function(o) {
    var o = $.extend({
      template           : $('#current-synset-tpl').text(),
      wordTemplate       : $('#word-tpl').text(),
      definitionTemplate : $('#definition-tpl').text(),
      onCancel           : function() {}
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorCurrentSynset.prototype = {
    currentSynsetId     : null,
    currentSynset       : null,
    selectedWords       : [],
    selectedDefinitions : [],
    //savedData           : null,
    changed             : false,

    initialize: function(o) {
      this.o = o
      this.handleAddCustomDefinition()
    },

    render: function(data) {
      $('#current-synset').remove()

      this.changed             = false
      this.selectedWords       = []
      this.selectedDefinitions = []
      //this.savedData           = data
      this.selectedWords       = data.words
      this.currentSynset       = $(Mustache.render(this.o.template, data))
      this.currentSynsetId     = data.id

      $('#synsets').append(this.currentSynset)
      this.handleRemoveWord()
      this.handleRemoveDefinition()
      this.handleApprove()
      this.handleCancel()
      this.validate()
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
      form.on('submit', $.proxy(function(e) {
        e.preventDefault()
        
        if (form.valid()) {
          modal.modal('hide')

          params = {
            definition : $(e.currentTarget).serializeObject(),
            synset_id  : this.currentSynsetId
          }

          console.log( params )
          //this.addDefinition({})
          this.validate()
          this.change()
        }
      }, this))

      // Submit form on click on dialog primary button
      modal.find('button.btn-primary').click(function() {
        form.submit()
      })
    },

    // TODO word should be a hash
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

      $('#current-words').append(newWord)
      this.handleRemoveWord()
      this.validate()
      this.change()
    },

    handleRemoveWord: function() {
      $('#current-words').on('click', 'i.icon', $.proxy(function(e) {
        var item = $(e.currentTarget).closest('div')

        this.selectedWords = $.grep(this.selectedWords, function(obj) {
          return obj.id != item.data('id')
        })

        item.remove()
        this.validate()
        this.change()
      }, this))
    },

    highlight: function() {
      $('#current-synset').toggleClass('active')
    },

    highlightWords: function() {
      $('#current-words').toggleClass('active')
    },

    addDefinition: function(definition) {
      if ($.grep(this.selectedDefinitions, function(obj, i) { return obj.id == definition.id }).length) {
        return
      }

      // Add new definition
      this.selectedDefinitions.push(definition)
      this.addWord({ id :definition.word_id, word : definition.word })

      var newDefinition = $(Mustache.render(this.o.definitionTemplate, definition))

      $('#current-synset ol').append(newDefinition)
      this.handleRemoveDefinition()
      this.validate()
      this.change()
    },

    handleRemoveDefinition: function() {
      this.currentSynset.find('li .icon-remove').click($.proxy(function(e) {
        var item = $(e.currentTarget).closest('li')

        this.selectedDefinitions = $.grep(this.selectedDefinitions, function(obj) {
          return obj.id != item.data('id')
        })

        item.remove()
        this.validate()
        this.change()
      }, this))
    },

    isChanged: function() {
      return this.changed
    },

    isValid: function() {
      return this.valid
    },

    change: function() {
      this.changed = true
      this.toggleCancelButton()
    },

    validate: function() {
      this.valid = this.selectedWords.length > 0 && this.selectedDefinitions.length > 0
      this.toggleApproveButton()
    },

    toggleCancelButton: function() {
      var btn = $('#current-synset .btn-cancel')

      if (this.isChanged()) {
        btn.removeClass('disabled')
      } else {
        btn.addClass('disabled')
      }
    },

    toggleApproveButton: function() {
      var btn = $('#current-synset .btn-approve')

      if (this.isValid()) {
        btn.removeClass('disabled')
      } else {
        btn.addClass('disabled')
      }
    },

    handleApprove: function() {
      $('#current-synset').on('click', '.btn-approve', $.proxy(function(e) {
        if (!this.isValid()) return
        console.log('save synset!')
      }, this))
    },

    // Need TODO: М.б. просто удалять текущий синсет вообще?
    handleCancel: function() {
      $('#current-synset').on('click', '.btn-cancel', $.proxy(function(e) {
        bootbox.confirm("Сбросить все изменения в текущем синсете?", "Нет, не надо", "Сбросить изменения", $.proxy(function(result) {
          if (result) { // Reset all changings in current synset
            this.reload()
            this.o.onCancel()
          }
        }, this))
      }, this))
    },

    load: function(synsetId) {
      $.getJSON('/synsets/' + synsetId + '.json', $.proxy(function(data) {
        this.render(data)
      }, this))
    },

    reload: function() {
      this.load(this.currentSynsetId)
    }
  }
})(jQuery);
