class ChangeInputNullableOnProblems < ActiveRecord::Migration[8.1]
  def change
    change_column_null :problems, :input, true
  end
end