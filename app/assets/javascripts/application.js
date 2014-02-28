//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.color
//= require mustache
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require jquery.validate.localization/messages_ru
//= require nprogress
//= require jquery.cookie

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
      } else if (jqXHR.status == 409) {
        alert('Извините, но кто-то только что отредактировал тот же синсет :( Страница будет обновлена.')
        window.location.reload();
      } else {
        alert('Неизвестная ошибка.\n' + jqXHR.responseText);
      }
    },
    beforeSend: function() {
      NProgress.start();
    },
    complete: function(){
      NProgress.done();
    },
  })

  // Snippet for serializing form to json
  $.fn.serializeObject = function()
  {
     var o = {};
     var a = this.serializeArray();
     $.each(a, function() {
         if (o[this.name]) {
             if (!o[this.name].push) {
                 o[this.name] = [o[this.name]];
             }
             o[this.name].push(this.value || '');
         } else {
             o[this.name] = this.value || '';
         }
     });
     return o;
  };

  // Nprogress
  NProgress.configure({ showSpinner: false });

  // Initialize editor
  var editorUi = $('#editor-ui')
  if (editorUi.length) {
    editorUi.editor()
  }
}).call(this);
