/*
  - Текущий синсет можно сохранить тогда, когда у него есть хоть одно слово и определение.
  - Его можно отменить. Тогда ему делается remove()
  - Если он валиден, то кнопка Сохранить становится активной
*/

(function( $ ) {
  $.fn.EditorCurrentSynset = function(o) {
    var o = $.extend({
      template           : $('#current-synset-tpl').text(),
      wordTemplate       : $('#word-tpl').text(),
      definitionTemplate : $('#definition-tpl').text(),
      //onBlur   : function(definition) {},
    }, o)

    this.initialize(o)
  }
  
  $.fn.EditorCurrentSynset.prototype = {
    currentSynset       : null,
    selectedWords       : [],
    selectedDefinitions : [],
    isPersisted         : false,

    initialize: function(o) {
      this.o = o

      this.handleAddCustomDefinition()
    },

    render: function(data) {
      this.selectedWords = data.words
      console.log(this.selectedWords)
      this.currentSynset = $(Mustache.render(this.o.template, data))

      $('#synsets').append(this.currentSynset)
      this.handleRemoveWord()
      this.handleRemoveDefinition()
    },

    handleAddCustomDefinition: function() {
      $('#add-definition-modal').find('button.btn-primary').click(function() {
        $('#add-definition-form').validate({
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

        $('#add-definition-form').submit()
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
    },

    handleRemoveWord: function() {
      $('#current-words').on('click', 'i.icon', $.proxy(function(e) {
        var item = $(e.currentTarget).closest('div')

        this.selectedWords = $.grep(this.selectedWords, function(obj) {
          return obj.id != item.data('id')
        })

        item.remove()
      }, this))
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
    },

    handleRemoveDefinition: function() {
      this.currentSynset.find('li .icon-remove').click($.proxy(function(e) {
        var item = $(e.currentTarget).closest('li')

        this.selectedDefinitions = $.grep(this.selectedDefinitions, function(obj) {
          return obj.id != item.data('id')
        })

        item.remove()
      }, this))
    }
  }
})(jQuery);
