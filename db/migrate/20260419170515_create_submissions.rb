class CreateSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :submissions do |t|
      t.references :problem, null: false, foreign_key: true
      t.text   :code,     null: false
      t.string :language, null: false, default: "python3"
      t.string :status,   null: false, default: "pending"
      t.text   :output

      t.timestamps
    end

    add_index :submissions, :status
  end
end