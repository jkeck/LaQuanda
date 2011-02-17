class Category < ActiveRecord::Base
  has_and_belongs_to_many :questions
  validates_uniqueness_of :name
  validates_presence_of :name
end
