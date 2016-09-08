class Word < ApplicationRecord
  belongs_to :category
  delegate :name, to: :category, prefix: true, allow_nil: true
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  has_many :answers, dependent: :destroy, inverse_of: :word
  has_many :lessons, through: :results

  enum search_word: [:all_word, :learned, :not_learned]
  validates :content, presence: true, length: {maximum: 20}

  accepts_nested_attributes_for :answers,
    reject_if: lambda {|a| a[:content].blank?}, allow_destroy: true

  QUERY_LEARNED = "id in (select results.word_id from
    results join lessons on results.lesson_id = lessons.id
    where lessons.user_id = ?)"

  QUERY_NOT_LEARNED = "id not in (select results.word_id from
    results join lessons on results.lesson_id = lessons.id
    where lessons.user_id = ?)"
  scope :word_by_category, ->category_id{where category_id: category_id}

  scope :search_word, -> search_name {
    where "content LIKE :search_name",
    search_name: "%#{search_name}%"
  }

  scope :learned, -> user_id{
    where QUERY_LEARNED, user_id
  }

  scope :not_learned, -> user_id{
    where QUERY_NOT_LEARNED, user_id
  }

  scope :filter_word, ->user_id{
    where SEARCH, user_id
  }

  class << self
    def search search_name
      search_word search_name
    end

    def filter user_id, type
      if type == "learned"
        learned user_id
      elsif type =="not_learned"
        not_learned user_id
      else
        all
      end
    end
  end
end
