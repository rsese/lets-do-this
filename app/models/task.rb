# == Schema Information
# Schema version: 20110517043331
#
# Table name: tasks
#
#  id             :integer         not null, primary key
#  description    :string(255)
#  completed      :boolean
#  position       :integer
#  created_by_id  :integer
#  assigned_to_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Task < ActiveRecord::Base
  attr_accessible :description, :completed, :position, :assigned_to_id

  belongs_to :created_by, :class_name => "User", :foreign_key => "user_id"
  belongs_to :assigned_to, :class_name => "User", :foreign_key => "user_id"

  validates :description, :presence => true,
                          :length =>{ :maximum => 256 }
  validates :created_by_id, :presence => true
end
