class AddDifficultyToProblems < ActiveRecord::Migration[7.2]
  def change
    add_column :problems, :difficulty, :string, null: false, default: "easy"
  end
end