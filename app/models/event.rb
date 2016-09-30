class Event < ApplicationRecord
  has_many :organization_events
  has_many :organizations, through: :organization_events
  validates :title, uniqueness: true
  validates_uniqueness_of :hostname, scope: :title
end
