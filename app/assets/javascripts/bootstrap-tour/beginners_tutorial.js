//= require bootstrap-tour
//= require watch

function BeginnersTutorial()
{
  this.tour = new Tour({});
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
    content: "<b>Синсет</b> - это набор синонимов объединенных под одним \
      определением. Например: авто, автомобиль, машина - средство передвижения.",
    backdrop: true,
    orphan: true
  });
  this.tour.addStep({
    title: "Выбор слова",
    element: '#choice-word',
    content: "Выбери слово с которым хочешь работать и нажми <выбрать>.",
    reflex: true,
    next: -1
  });
  this.tour.addStep({
    title: "Блок с синсетами",
    element: '#synsets',
    placement: 'bottom',
    backdrop: true,
    content: "В данном блоке находятся уже созданные синсеты. \
      Синсеты не должны повторяться."
  });
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
    element: '#synonymes',
    backdrop: true,
    content: "Выбери синонимы подходящие под данный синсет. \
      После этого нажми <далее>."
  });
  this.tour.addStep({
    title: "Определение для синсета",
    element: '#default-definition',
    reflex: true,
    backdrop: true,
    placement: 'bottom',
    content: "Осталось написать главное определение для синсета и твое \
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
      this.runTour();
    }
  },

  isEditorExists: function() {
    var editorUi = $('#editor-ui');
    if (editorUi.length)
      return true;
    else
      return false;
  },

  initTour: function() {
    this.tour.init();
  },

  runTour: function() {
    this.tour.start();
  },

  goToNextStep: function() {
    this.tour.goTo(this.tour.getCurrentStep()+1);
  },

  initHandlers: function () {
    // This needs because bootstraptour #reflex not handle <button>
    $("#choice-word").on('click', $.proxy(function() {
      this.tour.next();
    }, this))

    // This needs because bootstraptour needs displayed css.
    // So we watch when display:none removing from #editor-area and then
    // go next step by boostraptour
    $("#editor-area").watch('display', $.proxy(function() {
      this.goToNextStep();
    }, this))
  }

};
