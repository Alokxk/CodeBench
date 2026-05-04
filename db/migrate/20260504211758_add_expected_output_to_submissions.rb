class AddExpectedOutputToSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :submissions, :expected_output, :text
  end
end
