//////////////////////////////////////////////////////////////////////////
// Variables


//////////////////////////////////////////////////////////////////////////
$("#searchbar #word").select2({
  placeholder: "Введите слово",
  allowClear: true,
  /*ajax: {
    url: "/words.json",
    dataType: 'json',
    quietMillis: 100,
    data: function (term, page) {
      return {
        q: term,
        page_limit: 10,
      };
    },
    results: function (data, page) {
      console.log({ text: data.word, id: data.id })
      return { results: { text: data.word, id: data.id } }
    }
  }*/
}).on("change", function(e) { // When select a word
  var wordId = $("#searchbar #word").val()
  $.getJSON('/editor/word.json', { word_id: wordId }, function(data) {
    Editor.initialize(wordId, data)
  })
})



var Editor = {
  wordId:        null,
  leftPane:      $('#left-pane'),
  rightPane:     $('#right-pane'),
  actionPane:    $('#action-pane'),
  currentWords:  $('#current-words'),
  selectedWords: [],
  currentSynset: $('#current-synset'),
  currentSynsetDefinitions: $('#current-synset ol'),
  rightColumn:   $('#right-column'),
  editorArea:    $('#editor-area'),
  currentDefinition: function() { return $('.definitions ul li.active') },

  listingTemplate: $('#listing-tpl').text(),
  accordionTemplate: $('#accordion-tpl').text(),
  synsetsTemplate: $('#synsets-tpl').text(),
  addDefinitionFormTemplate: $('#add-definition-form-tpl').text(),
  wordDefinitionsPlaceholder: $('#word-definitions-placeholder'),
  synonymesPlaceholder: $('#synonymes-placeholder'),
  synsetsPlaceholder: $('#synsets-placeholder'),
  addToCurrentSynsetBtn: $('#add-to-current-synset-btn'),
  synonymes: function() { return $('#synonymes') },
  synsets: $('#synsets'),
  currentWord: $('.current-word'),
  addWord: function() { return $('.add-word') },
  definitionsLists: function() { return $('.definitions ul') },

  // Constructor
  initialize: function(wordId, data) {
    this.wordId = wordId

    this.editorArea.show()
    this.updateCurrentWordPlaceholders(data.word)
    this.renderDefinitions(data.definitions)
    this.renderSynonymes(data.synonymes)
    this.renderSynsets(data.synsets)
    this.setCurrentSynsetBtnHeight()

    this.synonymes().on('show', this.toggleIcon).on('hide', this.toggleIcon)
    this.synonymes().on('shown', this.setCurrentSynsetBtnHeight).on('hidden', this.setCurrentSynsetBtnHeight)

    // TODO: Move to separate object
    this.handleAddWordHover()
    this.handleAddWord()
    this.handleRemoveWord()

    // TODO: Move to separate object
    this.handleCurrentSynsetBtnHover()
    this.handleCurrentSynsetBtn()

    this.handleDefinitionsLists()

    // Handle 'Add synset' btn
    this.handleAddSynsetBtn()
    this.handleSynsetsList()

    this.handleAddDefinitionModal();

    $(document).click($.proxy(function(e) {
      if (this.currentDefinition() != null) {
        this.currentDefinition().removeClass('active')
        //this.currentDefinition() = null
      }

      this.addToCurrentSynsetBtn.addClass('disabled')
    }, this))
  },

  // Handle add definition to current synset btn
  handleAddDefinitionModal: function() {
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
          element.addClass('valid')
          .closest('.control-group').removeClass('error')
        }
      })

      $('#add-definition-form').submit()
    })
  },

  // Left column: render current word definitions list
  renderDefinitions: function(definitions) {
    this.wordDefinitionsPlaceholder.html(
      Mustache.render(this.listingTemplate, { definitions: definitions })
    )
  },

  // Left column: render current word synonymes with its definitions
  renderSynonymes: function(synonymes) {
    var counter = 0
    var accordionView = {
      count: function() {
        return function (text, render) { return counter++ }
      },
      hasDefinitions: function() { return this.definitions.length > 0 },
      expandFirst: function() { return counter == 1 },
      synonymes: synonymes
    }

    this.synonymesPlaceholder.html(
      Mustache.render(this.accordionTemplate, accordionView, { definitions: this.listingTemplate })
    )
  },

  // Render synsets definitions for right-top area
  renderSynsets: function(synsets) {
    this.synsetsPlaceholder.html(
      Mustache.render(this.synsetsTemplate, { synsets: synsets })
    )
  },

  // Set current cynset button height
  setCurrentSynsetBtnHeight: function() {
    if (this.rightColumn) {
      this.addToCurrentSynsetBtn.css('height', this.rightColumn.height())
    }
  },

  // Toggle synonymes collapse icons
  toggleIcon: function(e) {
    var icon = $(e.target).prev('.accordion-heading').find('a > i.icon')

    if (icon.hasClass('icon-plus')) {
      icon.removeClass('icon-plus').addClass('icon-minus')
    } else {
      icon.removeClass('icon-minus').addClass('icon-plus')
    }
  },

  // Handle add-word hover
  handleAddWordHover: function() {
    currentWords = this.currentWords

    this.addWord().hover(function() {
      currentWords.addClass('active')
    }, function() {
      currentWords.removeClass('active')
    })
  },

  // Click on 'add-word' button
  handleAddWord: function() {
    $('#synonymes .add-word').on('click', $.proxy(function(e) {
      e.stopPropagation()
      e.preventDefault()
      this.createWord($(e.target).data('word'))
    }, this))
  },

  createWord: function(word) {
    //existentWords = $('#current-words').data('words').split(/[\s+/) //|| []
    //console.log($('#current-words').data('words'))
    //console.log(word)
    
    // Do not add new word if already exists
    if ($.inArray(word, this.selectedWords) !== -1) {
      return
    }

    var wrapper = $(document.createElement('div'))
      .data('word', word)

    var span = $(document.createElement('span'))
      .attr('title', 'Добавить в текущий синсет')
      .html(word)

    var icon = $(document.createElement('i'))
      .attr('title', 'Удалить')
      .addClass('icon icon-remove')

    $('#current-words').append(
      wrapper.append(span, icon)
    )

    // Add new word to data attributes
    this.selectedWords.push(word)
    //$('#current-words').attr('data-words', this.selectedWords.join(' '))

    // Highlite insertion
    wrapper
      .css('background-color', '#38B2E5')
      .animate({
        backgroundColor: '#eeeeee',
      }, { duration: 700 })
  },

  // Remove word from current synset
  handleRemoveWord: function() {
    selectedWords = this.selectedWords//.data('words').split(/\s+/) || []

    this.currentWords.on('click', 'i.icon', function() {
      var wrapper = $(this).closest('div')
      selectedWords.splice($.inArray(wrapper.data('word'), selectedWords), 1)
      wrapper.remove()
    })
  },

  // Handle hover on add-to-current-synset-btn
  handleCurrentSynsetBtnHover: function() {
    currentSynset = this.currentSynset

    this.addToCurrentSynsetBtn.hover(function(e) {
      if (!$(this).hasClass('disabled')) currentSynset.addClass('active')
    }, function() {
      currentSynset.removeClass('active')
    })
  },

  // Handle click on add-to-current-synset-btn
  handleCurrentSynsetBtn: function() {
    var that = this
    currentDefinition = this.currentDefinition()
    currentSynsetDefinitions = this.currentSynsetDefinitions

    this.addToCurrentSynsetBtn.click(function(e) {
      e.stopPropagation()

      if (currentSynsetDefinitions.find('[data-id="' + currentDefinition.data('id') + '"]').length == 0) {
        var icon = $(document.createElement('i'))
          .attr('title', 'Удалить')
          .addClass('icon icon-remove')
          .click(function() {
            $(this).closest('li').remove()
          })

        newDefinition = currentDefinition
          .clone()
          .removeClass('active')
          .append(icon)

        that.createWord(newDefinition.data('word'))
        currentSynsetDefinitions.append(newDefinition)
      }
    })
  },

  handleAddSynsetBtn: function() {
    var that = this

    this.synsets.find('a').click(function(e) {
      e.preventDefault()

      $.post('/editor/create_synset', { word_id: that.wordId }, function(data) {
        that.renderSynsets(data.synsets)
        that.currentSynset.show()
        that.handleSynsetsList()

        // Highligth new synset
        var synsetsList = that.synsets.find('ul')
        var synsetsWrapper = that.synsets.find('ul').closest('div')
        synsetsList.find('[data-id="' + data.id + '"]').addClass('active')
        synsetsWrapper[0].scrollTop = synsetsWrapper[0].scrollHeight
      })
    })
  },

  // Handle word definitions lists
  handleDefinitionsLists: function() {
    currentDefinition = this.currentDefinition()
    addToCurrentSynsetBtn = this.addToCurrentSynsetBtn
    
    this.definitionsLists().on('click', 'li', function(e) {
      e.stopPropagation()

      if (currentDefinition != null) {
        currentDefinition.removeClass('active')
      }

      currentDefinition = $(this).addClass('active')

      // Make add-to-current-synset-btn active
      addToCurrentSynsetBtn.removeClass('disabled')
    })
  },

  // Update current word placeholders
  updateCurrentWordPlaceholders: function(word) {
    this.currentWord.html(word)
  },

  handleSynsetsList: function() {
    var synsetsList = this.synsets.find('ul')

    selectedSynset = synsetsList.find('li.active')
    
    synsetsList.on('click', 'li', function(e) {
      e.stopPropagation()

      if (selectedSynset != null) {
        selectedSynset.removeClass('active')
      }

      selectedSynset = $(this).addClass('active')
    })
  }
}

