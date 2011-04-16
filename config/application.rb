require File.expand_path('../boot', __FILE__)

# Load required parts of rails
require 'rails'
['active_record', 'action_controller', 'action_mailer'].each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end

# Load the UUID helper
require_relative '../lib/uuid_helper'
# Load the scraping code
require_relative '../lib/rincex_scraper'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Scraper
  class Application < Rails::Application
    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Use RSpec generators
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end

