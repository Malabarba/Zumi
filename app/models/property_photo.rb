class PropertyPhoto < ApplicationRecord
  acts_as_paranoid

  def self.permitted_params
    %i(file property_id)
  end

  admin_index_columns do
    %i(property file_file_name file_content_type url)
  end

  serialize_with(:id, :file)

  belongs_to :property

  has_attached_file :file,
                    preserve_files: true,
                    styles: { thumb: '65x50#',
                              small: '260x200>',
                              medium: '500x400>',
                              big: '2400x1600>' }
  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aimage/},
                       size: { less_than: 30.megabytes }

  before_save :randomize_name, if: :file_file_name_changed?

  private

  def randomize_name
    self.file_file_name = SecureRandom.base64(30).tr('/', '_')
  end
end
