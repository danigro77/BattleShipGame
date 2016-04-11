class Player < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name, :password

  scope :get_online, -> (id) { where(logged_in: true).where.not(id: id).order('LOWER(name) ASC') }
end
