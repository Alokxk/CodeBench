class CreateProblems < ActiveRecord::Migration[8.1]
  def change
    create_table :problems do |t|
      t.string :title,           null: false
      t.text   :description,     null: false
      t.text   :input,           null: false
      t.text   :expected_output, null: false

      t.timestamps
    end
  end
end