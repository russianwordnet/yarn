//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require select2
//= require jquery.color
//= require mustache
//= require bootbox
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.validate.localization/messages_ru

// Editor
//= require editor

(function() {
  var flash_messages;

  flash_messages = function() {
    return $(document).ready(function() {
      var close, hideMessages, messages;
      messages = $('#flash-messages');
      if (messages) {
        close = messages.find('a');
        hideMessages = function() {
          return messages.animate({
            top: -messages.height()
          }, 400, function() {
            return messages.hide();
          });
        };
        close.click(function(e) {
          e.preventDefault();
          return hideMessages();
        });
        return close.delay(2500).queue(function() {
          return $(this).trigger("click");
        });
      }
    });
  };

  flash_messages();

  // Spinner ajax indicator
  var Spinner = {
    show: function() {
      $('#spinner').show()
    },

    hide: function() {
      $('#spinner').hide()
    }
  }

  // Setup ajax error handling & callbacks
  $.ajaxSetup({
    error: function(jqXHR, exception) {
      if (jqXHR.status === 0) {
        alert('Нет соединения. Проверьте соединение с интернетом');
      } else if (jqXHR.status == 404) {
        alert('Запрашиваемая страница не найдена. Ошибка 404');
      } else if (jqXHR.status == 500) {
        alert('Ошибка сервера 500.');
      } else if (exception === 'parsererror') {
        alert('Парсинг запрашиваемого JSON не удался.');
      } else if (exception === 'timeout') {
        alert('Время ожидания истекло');
      } else if (exception === 'abort') {
        alert('Ajax запрос оклонён.');
      } else {
        alert('Неизвестная ошибка.\n' + jqXHR.responseText);
      }
    },
    beforeSend: function() {
      Spinner.show()
    },
    complete: function(){
      Spinner.hide()
    },
  })

  // Initialize editor
  var editorUi = $('#editor-ui')
  if (editorUi.length) {
    editorUi.editor()
  }
}).call(this);
