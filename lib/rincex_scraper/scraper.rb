module RincexScraper

def self.get(server, path, username, password)
  puts "GET #{path}"
  # Send request
  http = Net::HTTP.new(server,443)
  req = Net::HTTP::Get.new(path)
  http.use_ssl = true
  req.basic_auth username, password
  # Return response
  Nokogiri::HTML(http.request(req).body)
end

def self.link_details(link_node, type)
  row = link_node.parent.parent
  date_string = row.xpath('td[@nowrap]').text.strip

  author = row.xpath('td[@nowrap]/a/img[@src = "../images/mailto.gif"]/parent::node()')
  unless author.empty?
    author_email = author.xpath('img').first['title']
    author_name = author.text.strip
  else
    author_name = row.xpath('td[4]').text.strip
    author_email = nil
  end

  # Strip non-ascii from start of author name
  author_name.slice!(0) if author_name.each_byte.first == 194

  begin
    date = Date.strptime(date_string, '%d-%b-%Y')
  rescue ArgumentError
    date = Chronic.parse(date_string)
  end

  { :date => date, :author_name => author_name, :author_email => author_email,
    :type => type, :text => link_node.text, :url => link_node['href'],
    :params => Addressable::URI.parse(link_node['href']).query_values }
end

def self.scrape(page)
  # Grab directory links
  dir_links = page.xpath('//a[@target = "view"]').find_all do |a|
    /FUSEACTION=GetDirContents/ === a['href'] and
    /[\d\w]+/ === a.text
  end
  # Grab publishing links
  publishing_links = page.xpath('//a').find_all do |a|
    /selectPublishing/ === a['href']
  end
  # Grab file links
  file_links = page.xpath('//a[@target = "_blank"]').find_all do |a|
    /fuseaction=GetFile/ === a['href'] and
    /[\d\w]+/ === a.text
  end

  # Grab the details for all those links
  links = dir_links.collect {|a| link_details(a, :dir)} +
          publishing_links.collect {|a| link_details(a, :publishing)} +
          file_links.collect {|a| link_details(a, :file)}

  # Grab other page details
  details = {
    :page_title => page.xpath('//title').text,
    :title => page.xpath('//textarea[@name="FILE_TITLE"]').text,
    :description => page.xpath('//textarea[@name="FILE_DESC"]').text
  }

  # Return everything, ready for processing
  [links, details]
end

def self.update_links(links, details, parent)
  # Update the last scraped date of the parent
  if parent
    parent.last_scraped = Time.now
    if parent.item_type == 'publishing'
      parent.description = details[:description]
    end
    parent.save
  end

  # Add in all the new links
  links.each do |link|
    next unless link

    # Set up the item hash ready to be inserted into our database
    item = { :rincex_date => link[:date],
             :item_type => link[:type],
             :name => link[:text],
             :title => details[:title],
             :description => details[:description],
             :parent_id => parent.id }

    # Populate the Rincex identifiers depending on item type
    case link[:type]
    when :dir
      item[:rincex_project_id] = link[:params]['KEY_PROJECT_NUMBER']
      item[:rincex_dir_id] = link[:params]['KEY_FOLDER_ITEM_SEQ']
    when :publishing
      item[:rincex_project_id] = parent.rincex_project_id
      item[:rincex_dir_id] = parent.rincex_dir_id
      item[:rincex_publishing_id] = link[:url].scan(/\d+/).first
    when :file
      item[:rincex_project_id] = link[:params]['KEY_PROJECT_NUMBER']
      item[:rincex_publishing_id] = link[:params]['KEY_FILE_SEQ']
      item[:rincex_file_id] = link[:params]['KEY_FILE_ITEM_SEQ']
    end

    # Create the item record
    rincex_id_type = "rincex_#{link[:type]}_id".intern
    item_record = Item.send "find_by_#{rincex_id_type}", item[rincex_id_type]
    unless item_record
      item_record = Item.create(item)
    else
      item_record.update_attributes(item)
    end

    # Update the item's author if we have it
    if link[:author_name] and not link[:author_name].empty?
      item_record.author = Author.find_or_create_by_name(:name => link[:author_name],
                                                         :email => link[:author_email])
      # Add author's email if we didn't store it earlier
      if link[:author_email] and
          not link[:author_email].empty? and not item_record.author.email
        item_record.author.email = link[:author_email]
        item_record.author.save
      end

      item_record.save
    end
  end
end

def self.spider(item, older_than)
  response = get(APP_CONFIG['rincex_server'],
                 item.path, APP_CONFIG['rincex_user'],
                 APP_CONFIG['rincex_password'])
  links, details = scrape(response)
  update_links(links, details, item)

  leafs = Item.where("parent_id = ? and item_type in ('dir', 'publishing')" +
                     "and (last_scraped < ? or last_scraped is NULL)", item.id, older_than)
  leafs.each {|leaf| spider(leaf, older_than) }
end

def self.index
  # Create / update root record
  root = Item.find_by_rincex_dir_id APP_CONFIG['rincex_root_dir_id']
  unless root
    root = Item.create({ :rincex_dir_id => APP_CONFIG['rincex_root_dir_id'],
                         :item_type => 'dir',
                         :name => "#{APP_CONFIG['rincex_project_name']} (#{APP_CONFIG['rincex_project_id']})",
                         :last_scraped => Time.now })
  else
    root.last_scraped = Time.now
    root.save
  end

  spider root, Time.now
end

end
