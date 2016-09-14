class Activity < ApplicationRecord
  belongs_to :user

  enum activity_type: ["login", "logout", "following", "learned"]

  scope :order_by_time, -> {order created_at: :desc}
  scope :feed, -> following_ids, user_id {where "user_id IN (?) OR user_id = ?",
    following_ids, user_id}

  def target
    if following?
      User.find_by_id target_id
    elsif learned?
      Category.find_by_id target_id
    end
  end
end
