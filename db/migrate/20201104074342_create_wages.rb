class CreateWages < ActiveRecord::Migration[6.0]
  def change
    create_table :wages do |t|
      t.integer    :end_time, null: false
      t.integer    :paying,   null: false
      t.references :user, foreign_key: true
      t.references :work, foreign_key: true
      t.timestamps
    end
  end
end
