# frozen_string_literal: true

require 'json-schema'
require 'uri'

PHONE_NUMBER_REGEX = '^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$'

# ProfileConfigSchema module is used to validate json file for user profile
module ProfileConfigSchema
  def self.validate!(config)
    JSON::Validator.validate!(schema, config)
  end

  # rubocop:disable Metrics/MethodLength
  def self.schema
    apply do
      object(
        email: { type: 'string', pattern: URI::MailTo::EMAIL_REGEXP },
        goal: { type: 'string', minLength: 20 },
        programming_languages: { type: 'string', minLength: 5 },
        current_job: { type: 'string' },
        age: { type: 'integer', minimum: 18 },
        english: { enum: %i[a1 a2 b1 b2 c1 c2] },
        laptop: { enum: %i[yes no] },
        phone_number: { type: 'string', pattern: PHONE_NUMBER_REGEX },
        education: { type: 'string', minLength: 30 },
        past_job_experience: { type: 'string', minLength: 5 },
        location: { type: 'string' },
        url_to_repo: {type: 'string', pattern: URI.regexp }
      ).freeze
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.object(props)
    req = props.delete(:required) || props.keys.map(&:to_s)
    {
      type: 'object',
      required: req,
      properties: props
    }
  end

  def self.apply(&block)
    instance_eval(&block)
  end
end
