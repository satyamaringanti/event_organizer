class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :hostname, :organizations, :event_date_time

  def organizations
    object.organizations.present? ? object.organizations.map(&:name) : nil
  end

  def event_date_time
    object.created_at.strftime("%d-%m-%Y %H:%M:%S")
  end
end
