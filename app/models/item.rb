class Item < ActiveRecord::Base
  include UUIDHelper
  belongs_to :author
  belongs_to :parent, :class_name => "Item"
  has_many :children, :class_name => "Item", :foreign_key => "parent_id"

  named_scope :root, :conditions => {:rincex_dir_id => APP_CONFIG['rincex_root_dir_id']}

  def path
    case self.item_type
      when 'dir'
        query = { :FUSEACTION => 'GetDirContents',
                  :KEY_FOLDER_ITEM_SEQ => self.rincex_dir_id,
                  :KEY_PROJECT_NUMBER => APP_CONFIG['rincex_project_id'] }
      when 'publishing'
        query = { :FUSEACTION => 'PublishEdit',
                  :KEY_PROJECT_NUMBER => APP_CONFIG['rincex_project_id'],
                  :KEY_FILE_SEQ => self.rincex_publishing_id,
                  :target => 'view' }
      when 'file'
        query = { :fuseaction => 'GetFile',
                  :KEY_FILE_SEQ => self.rincex_publishing_id,
                  :KEY_FILE_ITEM_SEQ => self.rincex_file_id,
                  :KEY_PROJECT_NUMBER => APP_CONFIG['rincex_project_id'] }
    end

    '/FileShare/index.cfm?' + query.to_query
  end

  def url
    'https://' + APP_CONFIG['rincex_server'] + path
  end
end
