class ItemsController < ApplicationController
  respond_to :html
  skip_before_filter :authenticate, :only => :feed

  def index
    @items = Item.all

    respond_with(@items)
  end

  def feed
    @items = Item.where('item_type = ?', :file).order("rincex_date desc")

    respond_to do |format|
      format.atom
    end
  end
end
