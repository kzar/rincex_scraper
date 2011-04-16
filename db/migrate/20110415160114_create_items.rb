class CreateItems < ActiveRecord::Migration
  def self.up
    # Create the documents table
    create_table :items, :id => false do |t|
      # Primary key :id
      t.string :id, :limit => 36, :primary => true
      # Foreign keys
      t.string :parent_id, :limit => 36
      t.string :author_id, :limit => 36
      # Details
      t.string :rincex_project_id
      t.string :rincex_dir_id
      t.string :rincex_publishing_id
      t.string :rincex_file_id
      t.date :rincex_date
      t.string :item_type
      t.string :name
      t.string :title
      t.string :description
      t.datetime :last_scraped
      # The ubiquitous timestamps!
      t.timestamps
    end

    # Store uuid's efficiently if we're using Postgres
    ActiveRecord::convert_to_native_uuid('items', 'id')
    ActiveRecord::convert_to_native_uuid('items', 'parent_id')
    ActiveRecord::convert_to_native_uuid('items', 'author_id')
  end

  def self.down
    drop_table :items
  end
end
