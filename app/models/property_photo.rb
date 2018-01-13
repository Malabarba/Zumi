class PropertyPhoto < ApplicationRecord
  acts_as_paranoid

  def self.permitted_params
    %i(file property_id)
  end

  admin_index_columns do
    %i(property file_file_name file_content_type url)
  end

  serialize_with(:id, :url)

  belongs_to :property

  has_attached_file :file, { preserve_files: true }
  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aimage/},
                       size: { less_than: 30.megabytes }

  before_save :randomize_name, if: :file_file_name_changed?
  delegate :url, to: :file

  private

  def randomize_name
    self.file_file_name = SecureRandom.base64(30).tr('/', '_')
  end
end
