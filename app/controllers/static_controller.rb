# frozen_string_literal: true

class StaticController < ApplicationController
  def index_file
    response.headers['Content-Type'] = 'text/html'
    render file: Rails.public_path.join('index.html'), layout: false
  end
end
