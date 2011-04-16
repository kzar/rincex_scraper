# Load our bespoke configuration from config.yml to APP_CONFIG
APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
