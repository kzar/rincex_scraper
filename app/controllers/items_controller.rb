class ItemsController < ApplicationController
  respond_to :html
  skip_before_filter :authenticate, :only => :feed

  def index
    @items = Item.all :order => "created_at"
    @items = order_items(@items)

    respond_with(@items)
  end

  def feed
    @items = Item.where('item_type = ?', :file).order("rincex_date desc")

    respond_to do |format|
      format.atom
    end
  end

  private

  # Order items by tree structure
  def order_items(items, parent=items.first)
    [parent, items.find_all {|i| i.parent_id == parent.id}.collect do |i|
      order_items(items, i)
    end].flatten
  end
end
