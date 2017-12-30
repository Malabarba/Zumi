class PropertyPhoto < ApplicationRecord
  acts_as_paranoid

  def self.permitted_params
    %i(file property_id)
  end

  set_index_columns do |user|
    %i(property file_file_name file_content_type url)
  end

  belongs_to :property

  has_attached_file :file, { preserve_files: true }
  validates_attachment :file,
                       presence: true,
                       content_type: { content_type: /\Aimage/},
                       size: { less_than: 30.megabytes }
end
