# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  included do
    def token(started_at = Time.zone.now)
      JsonWebToken.encode(payload: make_claims.merge('type' => 'access_token'),
                          starts_at: started_at,
                          expires_at: 1.day.from_now)
    end

    def refresh_token(started_at = Time.zone.now)
      JsonWebToken.encode(payload: make_claims.merge('type' => 'refresh_token'),
                          starts_at: started_at,
                          expires_at: 1.week.from_now,
                          valid_until: started_at + 1.year)
    end

    def revoke_all_tokens
      # Revoke tokens from 1s ago. This is to ensure we can
      # immediately generate a new one and it won't be revoked.
      self.expired_at = Time.zone.now - 1
    end

    def revoke_all_tokens_and_save
      revoke_all_tokens
      save
    end

    def token_pair(refresh_start = Time.zone.now)
      { token: token, refresh_token: refresh_token(refresh_start) }
    end
  end

  class_methods do
    def token_claims(user_type, &block)
      define_method :make_claims do
        { user_type => instance_eval(&block) }
      end
    end
  end

  class UnexpectedError < StandardError
  end
end
