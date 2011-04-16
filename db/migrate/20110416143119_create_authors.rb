class CreateAuthors < ActiveRecord::Migration
  def self.up
    # Create the authors table
    create_table :authors, :id => false do |t|
      # Primary key :id
      t.string :id, :limit => 36, :primary => true
      # Values
      t.string :name
      t.string :email
      # The ubiquitous timestamps!
      t.timestamps
    end

    # Store uuid's efficiently if we're using Postgres
    ActiveRecord::convert_to_native_uuid('authors', 'id')
  end

  def self.down
    drop_table :authors
  end
end
