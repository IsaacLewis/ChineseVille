class Building < ActiveRecord::Base
  belongs_to :village
  belongs_to :type, :class_name => "BuildingType"
  add_methods_of :type
end
