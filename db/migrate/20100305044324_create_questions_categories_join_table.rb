class CreateQuestionsCategoriesJoinTable < ActiveRecord::Migration
  def self.up
    create_table :categories_questions, :id => false do |t|
      t.integer :category_id
      t.integer :question_id
    end
  end

  def self.down
    drop_table :categories_questions
  end
end
