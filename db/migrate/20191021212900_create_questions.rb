class CreateQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :multiple_choice_questions do |t|
      t.text :question
      t.string :answer_1
      t.string :answer_2
      t.string :answer_3
      t.string :answer_4
      t.string :correct_answer
      t.timestamps
    end

    create_table :short_answer_questions do |t|
      t.text :question
      t.string :correct_answer
      t.timestamps
    end
  end
end
