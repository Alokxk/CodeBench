class AddTestResultsToSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :submissions, :test_cases_passed, :integer, default: 0
    add_column :submissions, :test_cases_total,  :integer, default: 0
  end
end