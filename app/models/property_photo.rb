class PropertyPhoto < ApplicationRecord
  acts_as_paranoid

  def self.permitted_params
    %i(file property_id description)
  end

  admin_index_columns do
    %i(property file_file_name file_content_type description)
  end

  serialize_with(:id, :file, :description)

  belongs_to :property

  attachment :file,
             public: true,
             styles: { thumb: '65x50#', small: '260x200>', medium: '500x400>' }
  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aimage/},
                       size: { less_than: 30.megabytes }

  before_save :randomize_name, if: :file_file_name_changed?

  UNCAPITALIZED = %w(a o uma um na no em da do de)
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
    self.file_file_name = SecureRandom.base64(30).tr('/', '_')
  end
end
