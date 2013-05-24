class ApplicationController < ActionController::Base
  protect_from_forgery

  attr_accessor :top_bar_word, :top_bar_synset, :top_bar_synset_word
  helper_method :top_bar_word, :top_bar_synset, :top_bar_synset_word
end
