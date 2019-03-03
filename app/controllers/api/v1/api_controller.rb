# frozen_string_literal: true

class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  include ::Rescuable

  private

  def j(h)
    render(json: h.as_json, status: 200)
  end

  def current_user!
    current_user || (raise ActiveRecord::RecordNotFound)
  end
end
