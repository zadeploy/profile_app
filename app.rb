# frozen_string_literal: true

require 'sinatra'
require_relative 'lib/profile_config_schema.rb'

set :show_exceptions, false

PROFILE_PATH = 'config/profile.json'

class InvalidProfileError< StandardError; end

before do
  content_type :json
end

get '/' do
  begin
    file = File.read(PROFILE_PATH)
    profile = JSON.parse(file).to_json
    ProfileConfigSchema.validate!(profile)
    profile
  rescue JSON::ParserError, Errno::ENOENT, JSON::Schema::ValidationError => e
    raise InvalidProfileError, e.message
  end
end

error InvalidProfileError do
  { status: 'invalid profile'}.to_json
end

not_found do
  {status: 'invalid path' }.to_json
end
