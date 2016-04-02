class EventSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time

  def start_time
    object.start_time.to_s(:date_time)
  end

  def end_time
    object.end_time.to_s(:date_time)
  end
end
