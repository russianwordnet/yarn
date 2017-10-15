class WordsFinderService
  def initialize(params)
    @params = params
  end

  def find
    scope = build_main_scope
    scope = apply_non_empty(scope)

    scope
      .where(deleted_at: nil)
      .page(page)
      .per(limit)
  end

  private

  def build_main_scope
    if @params[:q].present?
      Word.search(@params[:q]).
        order(['rank DESC', 'frequency DESC', 'word'])
    else
      Word.order('frequency DESC')
    end
  end

  def apply_non_empty(scope)
    return scope if @params[:non_empty].blank?

    scope.joins(:synset_words)
  end

  def page
    @params[:page].presence
  end

  def limit
    @params[:limit].presence
  end
end
