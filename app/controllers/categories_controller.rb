class CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :find_category, only: :show

  def index
    @categories = if params[:commit].present?
      Category.search_category params[:search]
    else
      Category.all
    end
    @categories = @categories.paginate page: params[:page], per_page: Settings.page
  end

  def show
    @lesson = @category.lessons.new
    @words = @category.words.paginate page: params[:page], per_page: Settings.page
  end

  private
  def find_category
    @category = Category.includes(words: :answers).find_by_id params[:id]
    if @category.nil?
      flash[:danger] = t "notice.not_category"
      redirect_to root_url
    end
  end
end
