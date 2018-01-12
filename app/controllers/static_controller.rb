class StaticController < ApplicationController
  def html_file
    response.headers['Content-Type'] = 'text/html'
    render file: Rails.public_path.join('index.html'), layout: false
  end
end
