class Event < ActiveRecord::Base

  # Associations
  belongs_to :user

  # Validations
  validates :start_time, :end_time, :user, presence: true
  with_options if: -> { both_time_present? } do
    validate :end_time_is_after_start_time
    validate :times_are_not_overlaping
  end

  private
    def end_time_is_after_start_time
      if end_time <= start_time
        errors.add(:end_time, "must be after the start time")
      end
    end

    def times_are_not_overlaping
      if Event.where("start_time < ?", end_time).where("end_time > ?", start_time)
              .where(user_id: user_id).where.not(id: id).any?
        errors.add(:base, "Event's time can not overlap with other event's time")
      end
    end

    def both_time_present?
      start_time.present? && end_time.present?
    end
end
