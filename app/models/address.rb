class Address < ApplicationRecord
  def self.permitted_params
    %i(street number complement neighborhood zip_code city state)
  end

  validates(*permitted_params, presence: true)

  def to_s
    permitted_params.map { |p| public_send(p).presence }
                    .compact.join(', ')
  end

  def to_s_short
    "#{street}, #{number}, #{complement}"
  end
end
