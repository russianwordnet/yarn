# encoding: utf-8

module WordsHelper
  def title_word(word)
    raw "№#{@word.id}: &laquo;#{@word.word}&raquo;"
  end
end