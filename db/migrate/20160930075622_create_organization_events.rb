class CreateOrganizationEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :organization_events do |t|
      t.references :event, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
