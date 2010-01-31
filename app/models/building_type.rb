class BuildingType < ActiveRecord::Base
  has_many :buildings
  has_attached_file :image, :styles => {:thumb => "100x100#"}

end
