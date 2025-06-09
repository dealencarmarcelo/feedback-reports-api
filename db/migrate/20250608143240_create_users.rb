class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.references :organization, type: :uuid, null: false, foreign_key: true

      t.string :name, null: false
      t.string :email, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
