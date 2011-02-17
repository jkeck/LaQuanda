class Question < ActiveRecord::Base
  has_and_belongs_to_many :categories
  validates_presence_of :question
  validates_presence_of :answer
end
