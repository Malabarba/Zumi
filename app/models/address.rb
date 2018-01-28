class Address < ApplicationRecord
  def self.permitted_params
    %i(street number complement neighborhood zip_code city state)
  end

  validates(*permitted_params, presence: true)
  SERIALIZED_PARAMS = [*permitted_params, :lat, :lng].freeze
  serialize_with(SERIALIZED_PARAMS)
  before_save :set_geolocation

  def to_s
    SERIALIZED_PARAMS.map { |p| public_send(p).presence }
                     .compact.join(', ')
  end

  def to_s_short
    "#{street}, #{number}, #{complement}"
  end

  def set_geolocation
    query = URI.encode_www_form(address: formatted_for_google_maps,
                                key: ENV['GOOGLE_MAPS_API_KEY'])
    geocode_url = URI::HTTPS.build(host: 'maps.googleapis.com',
                                   path: '/maps/api/geocode/json',
                                   query: query).to_s
    response_geo_code = RestClient::Request.new(method: :get,
                                                url: geocode_url,
                                                open_timeout: 10,
                                                timeout: 10).execute
    return if (result = JSON.parse(response_geo_code)['results'].first).blank?
    lat_lng = result['geometry']['location']
    assign_attributes(lat: lat_lng['lat'].to_f, lng: lat_lng['lng'].to_f)
  rescue StandardError => _
    false
  end

  def google_maps_url
    URI::HTTPS.build(host: 'www.google.com', path: '/maps',
                     query: URI.encode_www_form(q: formatted_for_google_maps)).to_s
  end

  private

  def formatted_for_google_maps
    "#{street}, #{number} - #{neighborhood}, #{city} - #{state}"
  end
end
