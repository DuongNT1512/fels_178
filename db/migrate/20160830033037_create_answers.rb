class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.string :content
      t.references :word, index: true, foreign_key: true
      t.boolean :is_correct

      t.timestamps
    end
  end
end
