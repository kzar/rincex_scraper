task :scrape => :environment do
  RincexScraper.index
end
