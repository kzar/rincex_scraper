class Author < ActiveRecord::Base
  include UUIDHelper
  has_many :items, :foreign_key => "item_id"

  def display_name
    if self.email
      name = self.email.split('@').first
      name.gsub(/[\._]/, ' ').titleize
    else
      self.name
    end
  end
end
