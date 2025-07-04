class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, null: false
      t.string :document, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
