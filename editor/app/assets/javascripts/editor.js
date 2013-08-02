//////////////////////////////////////////////////////////////////////////
// Variables
var leftPane      = $('#left-pane')
var rightPane     = $('#right-pane')
var actionPane    = $('#action-pane')
var currentWords  = $('#current-words')
var currentSynset = $('#current-synset')
var rightColumn   = $('#right-column')

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
  // TODO: Нужно выцепить слово из селекта, вставить его в плейсхолдеры интерфейса, получить список определений и синонимов
  // и вставить их в интерфейс.
  // definitions.json?word_id=6096
  alert($("#searchbar #word").val())
})

renderDefinitions()
function renderDefinitions() {
  var tpl = $('#listing-tpl').text()
  var view = {
    definitions: [
      'Word definition Word definition Word definition Word definition Word definition #1',
      'Word definition Word definition Word definition Word definition Word definition #2',
      'Word definition Word definition Word definition Word definition Word definition #3'
    ]
  }

  $('#word-definitions-placeholder').html(
    Mustache.render(tpl, view)
  )
}

renderSynonymes()
function renderSynonymes() {
  var counter = 0
  var accordionTpl = $('#accordion-tpl').text()
  var accordionView = {
    count: function() {
      return function (text, render) {
        return counter++
      }
    },
    hasDefinitions: function() { return this.definitions.length > 0 },
    expandFirst: function() {
      return counter == 1
    },
    synonymes: [
      {
        word_id: 777,
        word: 'Бытие',
        definitions: [
          'Word definition Word definition Word definition Word definition Word definition #1',
          'Word definition Word definition Word definition Word definition Word definition #2',
          'Word definition Word definition Word definition Word definition Word definition #3',
          'Word definition Word definition Word definition Word definition Word definition #4',
        ],
      },
      {
        word_id: 888,
        word: 'Разум',
        definitions: [
          'Word definition Word definition Word definition Word definition Word definition #1',
          'Word definition Word definition Word definition Word definition Word definition #2',
        ],   
      },
      {
        word_id: 999,
        word: 'Дни',
        definitions: [],
      },
    ]
  }

  $('#synonymes-placeholder').html(
    Mustache.render(accordionTpl, accordionView, { definitions: $('#listing-tpl').text() })
  )
}

//////////////////////////////////////////////////////////////////////////
// Set add-to-current-synset-btn height
var setCurrentSynsetBtnHeight = function() {
  $('#add-to-current-synset-btn').css('height', rightColumn.height())
}

setCurrentSynsetBtnHeight()

//////////////////////////////////////////////////////////////////////////
// Toggle synonymes collapse icons
var toggleIcon = function(e) {
  var icon = $(e.target).prev('.accordion-heading').find('a > i.icon')

  if (icon.hasClass('icon-plus')) {
    icon.removeClass('icon-plus').addClass('icon-minus')
  } else {
    icon.removeClass('icon-minus').addClass('icon-plus')
  }
}

$('#synonymes').on('show', toggleIcon).on('hide', toggleIcon)
$('#synonymes').on('shown', setCurrentSynsetBtnHeight).on('hidden', setCurrentSynsetBtnHeight)

//////////////////////////////////////////////////////////////////////////  
// Handle add-word hover
$('.add-word').hover(function() {
  currentWords.addClass('active')
}, function() {
  currentWords.removeClass('active')
})

//////////////////////////////////////////////////////////////////////////
// Click on 'add-word' button
var existentWords = currentWords.data('words').split(/\s+/) || []

$('#synonymes .add-word').on('click', function(e) {
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

//////////////////////////////////////////////////////////////////////////
// Remove words from current synset
$('#current-words').on('click', 'i.icon', function() {
  var wrapper = $(this).closest('div')
  existentWords.splice($.inArray(wrapper.data('word'), existentWords), 1)
  wrapper.remove()
})

//////////////////////////////////////////////////////////////////////////
// Handle hover on add-to-current-synset-btn
$('#add-to-current-synset-btn').hover(function(e) {
  if (!$(this).hasClass('disabled')) currentSynset.addClass('active')
}, function() {
  currentSynset.removeClass('active')
})

//////////////////////////////////////////////////////////////////////////
// Handle click on add-to-current-synset-btn
$('#add-to-current-synset-btn').click(function(e) {
  e.stopPropagation()
})

//////////////////////////////////////////////////////////////////////////
// Handle word definitions lists
// TODO Текущее определение из всех списков должно быть только одно походу, и если оно есть то нельзя убирать
// active с #add-to-current-synset-btn, а если кликаем вне списка, то убираем текущее определение и убираем 
// active с #add-to-current-synset-btn
var currentDefinition = $('.definitions ul li.active')

$('.definitions ul').on('click', 'li', function(e) {
  e.stopPropagation()

  if (currentDefinition != null) {
    currentDefinition.removeClass('active')
  }

  currentDefinition = $(this).addClass('active')

  // Make add-to-current-synset-btn active
  $('#add-to-current-synset-btn').removeClass('disabled')
})

//////////////////////////////////////////////////////////////////////////
// 
$(document).click(function(e) {
  //alert('Clicked on document!');
  if (currentDefinition != null) {
    currentDefinition.removeClass('active')
    currentDefinition = null
  }

  $('#add-to-current-synset-btn').addClass('disabled')
})
