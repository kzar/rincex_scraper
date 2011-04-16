task :scrape => :environment do
  RincexScraper.index
end

task :cron => :environment do
  RincexScraper.index
end
