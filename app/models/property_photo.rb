class PropertyPhoto < ApplicationRecord
  acts_as_paranoid

  def self.permitted_params
    %i(file property_id)
  end

  admin_index_columns do
    %i(property file_file_name file_content_type url)
  end

  serialize_with(:url)

  belongs_to :property

  has_attached_file :file, { preserve_files: true }
  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aimage/},
                       size: { less_than: 30.megabytes }
end
