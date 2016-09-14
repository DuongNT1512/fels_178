class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :activities, dependent: :destroy
  has_many :lessons, dependent: :destroy
  has_many :results, through: :lessons
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: "follower_id", dependent:   :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: "followed_id", dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  enum role: {admin: 1, student: 0}

  before_save :downcase_email
  has_secure_password

  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: 50}
  validates :password_digest, presence: true, length: {minimum: 1}

  def current_user? user
    self == user
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
    create_activity "following", other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end

  def create_activity activity_type, target_id = nil
    activities.create activity_type: activity_type, target_id: target_id
  end

  private
  def downcase_email
    self.email = email.downcase
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password_digest.create string, cost: cost
    end
  end
end
