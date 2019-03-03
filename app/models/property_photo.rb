# frozen_string_literal: true

class PropertyPhoto < ApplicationRecord
  acts_as_paranoid

  def self.permitted_params
    %i[file property_id description]
  end

  admin_index_columns do
    %i[property file_file_name file_content_type description]
  end

  serialize_with(:id, :file, :description)

  belongs_to :property

  attachment :file,
             public: true,
             path: '/:style/:class/:basename.:extension',
             s3_headers: { 'Cache-Control' => "max-age=#{365 * 24 * 60 * 60}" },
             styles: { thumb: '65x50#', small: '260x200>', medium: '500x400>' }
  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aimage/ },
                       size: { less_than: 30.megabytes }

  before_save :randomize_name, if: :file_file_name_changed?

  UNCAPITALIZED = %w[a o uma um na no em da do de].freeze
  def description=(s)
    if s.is_a?(String)
      super(s.downcase.strip.split
             .map { |w| UNCAPITALIZED.include?(w) ? w : w.capitalize }
             .join(' '))
    else
      super
    end
  end

  private

  def randomize_name
    base = SecureRandom.base64(40).tr('/', '_')
    self.file_file_name = "#{base}.#{File.extname(file_file_name || '')}"
  end
end
