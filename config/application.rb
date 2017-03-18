require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scope
  class Application < Rails::Application
    config.api_only = true
    config.secret_key_base = Figaro.env.secret_key_base
  end
end
