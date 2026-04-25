class AddTestCasesToProblems < ActiveRecord::Migration[7.2]
  def change
    add_column :problems, :test_cases, :jsonb, default: []
  end
end