class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :find_lesson, only: [:show, :update]

  def show
    check_lesson_status
    @remaining_time = @lesson.remaining_time
  end

  def index
    @lessons = current_user.lessons.paginate page: params[:page], per_page: Settings.page
    if @lessons.blank?
      flash[:danger] = t "lesson.not_lesson"
    end
  end

  def create
    @lesson = current_user.lessons.new lesson_params
    if @lesson.save
      flash[:success] = t "containt.start"
      redirect_to lesson_path @lesson
    else
      flash[:danger] = t "create_fail"
      redirect_to category_path
    end
  end

  def update
    if @lesson.update_attributes lesson_params
      check_lesson_status
      flash[:success] = t "lesson.finish"
    else
      flash[:danger] = t "lesson.update_fails"
    end
    redirect_to lesson_path @lesson
  end

  private
  def lesson_params
    params.require(:lesson).permit :category_id, :user_id, :status,
      results_attributes: [:id, :word_id, :answer_id]
  end

  def find_lesson
    @lesson = current_user.lessons.includes(results: [:answer, word: :answers]).
      find_by_id params[:id]
    if @lesson.nil?
      flash[:danger] = t "notice.not_lesson"
      redirect_to category_path
    end
  end

  def check_lesson_status
    if @lesson.init?
      @lesson.update_attributes status: :testing, started_at: Time.zone.now
    elsif @lesson.testing? && @lesson.time_out?
      flash[:danger] = t "lesson.time_out"
      @lesson.finished!
      redirect_to lesson_path @lesson
    end
  end
end
