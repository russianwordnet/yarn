# encoding: utf-8

class SeedMarks < ActiveRecord::Migration
  MARKS = {
    'Эмоциональные' => [
      { name: 'ласк.', description: 'ласкательное' },
      { name: 'уменьш.', description: 'уменьшительное' },
      { name: 'уменьш.-ласк.', description: 'уменьшительно-ласкательное' },
      { name: 'шутл.', description: 'шутливое' },
      { name: 'ирон.', description: 'ироническое' },
      { name: 'фам.', description: 'фамильярное' },
      { name: 'неодобр.', description: 'неодобрительное' },
      { name: 'пренебр.', description: 'пренебрежительное' },
      { name: 'презр.', description: 'презрительное' },
      { name: 'груб.', description: 'грубое' },
      { name: 'бран.', description: 'бранное' }
    ],
    'Стилистические' => [
      { name: 'высок.', description: 'высокое' },
      { name: 'книжн.', description: 'книжное' },
      { name: 'трад.-поэт.', description: 'традиционно-поэтическое' },
      { name: 'офиц.', description: 'официальное' },
      { name: 'разг.', description: 'разговорное' },
      { name: 'разг.-сниж.', description: 'разговорно-сниженное' },
      { name: 'жарг.', description: 'жаргонное' },
      { name: 'вульг.', description: 'вульгарное' },
      { name: 'эвф.', description: 'эвфемизм' },
      { name: 'мат.', description: 'матерное (матизм)' }
    ],
    'Хронологические' => [
      { name: 'неол.', description: 'неологизм' },
      { name: 'устар.', description: 'устаревшее' },
      { name: 'истор.', description: 'историческое (историзм)' },
      { name: 'совет.', description: 'советизм' }
    ],
    'Доменные и территориальные' => [
      { name: 'спец.', description: 'специальное' },
      { name: 'обл.', description: 'областное (диалектное)' }
    ],
    'Семантические' => [
      { name: 'перен.', description: 'переносное значение' },
    ]
  }

  def up
    MARKS.each do |title, marks|
      category = MarkCategory.create! title: title
      category.marks.create! marks
    end
  end

  def down
    MARKS.each_key { |title| MarkCategory.destroy_all(title: title) }
  end
end
