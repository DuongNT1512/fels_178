class WordsController < ApplicationController

  def index
    @filter_words = Word.search_words.map {|key, value|
      [t("word.search_word.#{key}"), key]}
    @words = if params[:commit].present?
      Word.search(params[:search]).filter current_user.id, params[:search_word]
    else
      Word.all
    end
    @words = @words.paginate page: params[:page], per_page: Settings.word_page
    respond_to do |format|
      format.html
      format.js
    end
  end
end
