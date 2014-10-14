//= require bootstrap-tour
//= require watch

function BeginnersTutorial()
{
  this.tour = new Tour({
    // Do not delete #name field, because it is also windowStorage name
    // and without it tour continuing after sign in will be broken.
    name: 'beginners-tutorial',
    template:  "<div class='popover tour'> \
    <div class='arrow'></div> \
    <h3 class='popover-title'></h3> \
    <div class='popover-content'></div> \
    <div class='popover-navigation'> \
        <button class='btn btn-default' data-role='prev'>« Назад</button> \
        <span data-role='separator'>|</span> \
        <button class='btn btn-default' data-role='next'>Далее »</button> \
    <button class='btn btn-default' data-role='end'>Выйти</button> \
    </div> \
    </nav> \
  </div>"
  });

  this.tour.addStep({
    title: "Начальный туториал",
    content: "Тебя привествует многоуважаемый компьютер. \
      Ты находишься в месте, где оперируют синсетами. \
      Сейчас я научу тебя основам этого искусства.",
    backdrop: true,
    orphan: true
  });

  this.tour.addStep({
    title: "Синсет",
    content: "<b>Синсет</b> - это множество синонимов, объединенных общим \
      смыслом. Например: авто, автомобиль, машина − средство передвижения.",
    backdrop: true,
    orphan: true
  });

  this.tour.addStep({
    title: "Выбор слова",
    element: '#choice-word',
    content: "Выбери слово, с которым хочешь работать, и нажми <выбрать>.",
    reflex: true,
    next: -1
  });

  this.SIGN_IN_STEP = 3;
  this.tour.addStep({
    title: "Вход",
    element: '#userbar',
    content: "Чтобы продолжить, необходимо осуществить вход в систему.",
    reflex: true,
    placement: 'left',
    next: -1,
    onShown: $.proxy(function(tour) {
      if (this.isCurrentUserAuthorized())
        this.goToNextStep();
    }, this)
  });

  this.tour.addStep({
    title: "Блок с синсетами",
    element: '#synsets',
    placement: 'bottom',
    backdrop: true,
    orphan: true,
    content: "В данном блоке находятся уже созданные синсеты. \
      Синсеты не должны повторяться."
  });

  // "next: -1" good to be here, but its not here because after click
  // 'Добавить синсет' ajax happens and bootstraptour fails
  this.tour.addStep({
    title: "Новый синсет",
    element: '#add-synset',
    reflex: true,
    backdrop: true,
    placement: 'bottom',
    content: "Нажми <добавить синсет> для создания нового синсета."
  });

  this.tour.addStep({
    title: "Выбор синонимов",
    element: '#left-pane',
    backdrop: true,
    placement: 'top',
    container: '#synonymes',
    content: "Выбери <b>синонимы</b>, подходящие под данный синсет. \
      После этого нажми <далее>."
  });

  this.tour.addStep({
    title: "Определение для синсета",
    element: '#default-definition',
    reflex: true,
    backdrop: true,
    placement: 'bottom',
    next: -1,
    content: "Осталось написать <b>главное определение</b> для синсета и твое \
      обучение завершится. Нажми на <карандашик>, чтобы написать определение."
  });
}

BeginnersTutorial.prototype = {
  constructor: BeginnersTutorial,

  run: function() {
    if (this.isEditorExists())
    {
      this.initHandlers();
      this.initTour();
      this.beginTour();
    }
  },

  beginTour: function() {
    try{
      this.tour.end();
    } catch(TypeError){
      this.tour.restart();
    }
    this.tour.restart();
    this.tour.start(true);
  },

  goToNextStep: function() {
    this.goToStep(this.tour.getCurrentStep()+1);
  },

  goToStep: function(stepNum) {
    this.tour.goTo(stepNum);
  },

  tryFromSignInStep: function() {
    this.goToStep(this.SIGN_IN_STEP);
  },

  initTour: function() {
    this.tour.init();
  },

  isEditorExists: function() {
    var editorUi = $('#editor-ui');
    if (editorUi.length)
      return true;
    else
      return false;
  },

  isInSignInStep: function() {
    return (this.tour.getCurrentStep() == this.SIGN_IN_STEP);
  },

  isCurrentUserAuthorized: function() {
    var authorized = true;
    $.ajax({
        url: "users/me.json",
        async: false,
        error: function(xhr, statusText, errorThrown){ authorized = false }
    });
    return authorized;
  },

  initHandlers: function () {
    // Bootstraptour needs displayed css. There are we watching
    // .word-picker-modal display attribute changing to goto next step.
    $(".word-picker-modal").watch('display', $.proxy(function() {
      this.goToNextStep();
    }, this));
  }
};
