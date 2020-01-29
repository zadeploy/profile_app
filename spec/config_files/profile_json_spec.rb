# frozen_string_literal: true

require 'json'
require_relative '../../lib/profile_config_schema.rb'

RSpec.describe 'config/profile.json' do
  file = File.read('config/profile.json')
  config = JSON.parse(file).to_json

  it 'has config that conforms to the profile config schema' do
    ProfileConfigSchema.validate!(config)
  end
end
