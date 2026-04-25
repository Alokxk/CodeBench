class AddExecutionTimeMsToSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :submissions, :execution_time_ms, :integer
  end
end