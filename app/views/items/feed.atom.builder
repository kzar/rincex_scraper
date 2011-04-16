atom_feed do |feed|
  feed.title("#{APP_CONFIG['rincex_project_name']} " +
             "(#{APP_CONFIG['rincex_project_id']})")
  feed.updated(Item.root.first.last_scraped)

  @items.each do |item|
    next if item.updated_at.blank?

    feed.entry(item, :url => item.url, :published => item.rincex_date, :updated => item.rincex_date) do |entry|
      entry.url(item.url)
      entry.title(item.name)
      entry.content(item.description)
      entry.updated(item.rincex_date)
      entry.author do |author|
        author.name(item.author.display_name)
        author.email(item.author.email)
      end
    end
  end
end
