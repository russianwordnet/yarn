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
