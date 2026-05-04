class AddFailingInputToSubmissions < ActiveRecord::Migration[7.2]
  def change
    add_column :submissions, :failing_input, :text
  end
end
