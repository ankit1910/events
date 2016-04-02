class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :start_time, :end_time
      t.belongs_to :user

      t.timestamps null: false
    end
  end
end
