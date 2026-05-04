class FixDifficultyDefault < ActiveRecord::Migration[7.2]
  def change
    change_column_default :problems, :difficulty, from: "easy", to: "Easy"
  end
end