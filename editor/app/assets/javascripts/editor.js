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
  $.getJSON('/editor/word.json', { word_id: $("#searchbar #word").val() }, function(data) {
    Editor.initialize(data)
  })
})

var Editor = {
  leftPane:      $('#left-pane'),
  rightPane:     $('#right-pane'),
  actionPane:    $('#action-pane'),
  currentWords:  $('#current-words'),
  currentSynset: $('#current-synset'),
  currentSynsetDefinitions: $('#current-synset .listing ul'),
  rightColumn:   $('#right-column'),
  editorArea:    $('#editor-area'),
  currentDefinition: function() { return $('.definitions ul li.active') },

  listingTemplate: $('#listing-tpl').text(),
  accordionTemplate: $('#accordion-tpl').text(),
  wordDefinitionsPlaceholder: $('#word-definitions-placeholder'),
  synonymesPlaceholder: $('#synonymes-placeholder'),
  addToCurrentSynsetBtn: $('#add-to-current-synset-btn'),
  synonymes: $('#synonymes'),
  currentWord: $('.current-word'),
  addWord: function() { return $('.add-word') },
  definitionsLists: function() { return $('.definitions ul') },

  // Constructor
  initialize: function(data) {
    this.editorArea.show()
    this.updateCurrentWordPlaceholders(data.word)
    this.renderDefinitions(data.definitions)
    this.renderSynonymes(data.synonymes)
    this.setCurrentSynsetBtnHeight()

    this.synonymes.on('show', this.toggleIcon).on('hide', this.toggleIcon)
    this.synonymes.on('shown', this.setCurrentSynsetBtnHeight).on('hidden', this.setCurrentSynsetBtnHeight)

    // TODO: Move to separate object
    this.handleAddWordHover()
    this.handleAddWord()
    this.handleRemoveWord()

    // TODO: Move to separate object
    this.handleCurrentSynsetBtnHover()
    this.handleCurrentSynsetBtn()

    this.handleDefinitionsLists()

    $(document).click($.proxy(function(e) {
      if (this.currentDefinition() != null) {
        this.currentDefinition().removeClass('active')
        //this.currentDefinition() = null
      }

      this.addToCurrentSynsetBtn.addClass('disabled')
    }, this))
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

  // Set current cynset button height
  setCurrentSynsetBtnHeight: function() {
    this.addToCurrentSynsetBtn.css('height', this.rightColumn.height())
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
    existentWords = this.currentWords.data('words').split(/\s+/) || []
    currentWords = this.currentWords

    $('#synonymes .add-word').on('click', function(e) {
      console.log(existentWords)
      e.stopPropagation()
      e.preventDefault()

      var newWord = $(this).data('word')

      // Do not add new word if already exists
      if ($.inArray(newWord, existentWords) !== -1) {
        return
      }

      var wrapper = $(document.createElement('div'))
        .data('word', newWord)

      var span = $(document.createElement('span'))
        .attr('title', 'Добавить в текущий синсет')
        .html(newWord)

      var icon = $(document.createElement('i'))
        .attr('title', 'Удалить')
        .addClass('icon icon-remove')

      currentWords.append(
        wrapper.append(span, icon)
      )

      // Add new word to data attributes
      existentWords.push(newWord)
      currentWords.attr('data-words', existentWords.join(' '))

      // Highlite insertion
      wrapper
        .css('background-color', '#38B2E5')
        .animate({
          backgroundColor: '#eeeeee',
        }, { duration: 700 })
    })
  },

  // Remove word from current synset
  handleRemoveWord: function() {
    existentWords = this.currentWords.data('words').split(/\s+/) || []

    this.currentWords.on('click', 'i.icon', function() {
      var wrapper = $(this).closest('div')
      existentWords.splice($.inArray(wrapper.data('word'), existentWords), 1)
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
    currentDefinition = this.currentDefinition()
    currentSynsetDefinitions = this.currentSynsetDefinitions

    this.addToCurrentSynsetBtn.click(function(e) {
      e.stopPropagation()

      if (currentSynsetDefinitions.find('[data-id="' + currentDefinition.data('id') + '"]').length == 0) {
        newDefinition = currentDefinition.clone().removeClass('active')
        currentSynsetDefinitions.append(newDefinition)
      }
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
  }
}

