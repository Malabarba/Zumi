# frozen_string_literal: true

require 'jwt'

class JsonWebToken
  def self.encode(payload: {},
                  starts_at:,
                  created_at: Time.zone.now,
                  expires_at: 3.hours.from_now,
                  valid_until: nil)
    payload = payload.dup
    payload['created_at'] = created_at.to_i
    payload['started_at'] = starts_at.to_i
    payload['exp'] = [expires_at, valid_until].compact.min.to_i
    JWT.encode(payload, Devise.secret_key)
  end

  def self.decode(token)
    JWT.decode(token, Devise.secret_key)
  end
end
