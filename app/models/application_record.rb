require 'securerandom'

class ApplicationRecord < ActiveRecord::Base
  has_paper_trail

  self.abstract_class = true
  # `type' is a very useful column name.
  self.inheritance_column = nil

  def self.inherited(model)
    super
    hash = { model.model_name.param_key => { updated_at: 'Atualizado em', created_at: 'Criado em' } }
    I18n.backend.store_translations(:'pt-BR', {activerecord: {attributes: hash } })
  end

  def update!(*)
    super && self
  end

  def save!(*)
    super && self
  end

  def add_error(key, msg)
    errors.add(key, msg)
    false
  end

  include Serializable
  include PermittedParams
  include Actionable

  class << self
    private

    def attachment(name, public:, path:, **opts)
      # bucket = "zumi-#{Rails.env}-paperclip#{public ? '' : '-private'}"
      bucket = "zumi-photos-staging#{public ? '' : '-private'}"
      s3_opts = if Rails.env.development? || Rails.env.test?
                  {}
                else
                  { storage: :s3,
                    url: ':s3_domain_url',
                    path: path,
                    s3_region: 'sa-east-1',
                    s3_credentials: { bucket: bucket,
                                      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] } }
                end
      has_attached_file name, **s3_opts.merge(opts)
    end

    def money(col, **opts)
      cents_col = :"#{col}_cents"
      monetize(cents_col, **opts)
      if col != cents_col && (name = human_attribute_name(col))
        hash = {activerecord: {attributes: {model_name.param_key => {cents_col => "#{name} (em centavos)"}}}}
        I18n.backend.store_translations(:'pt-BR', hash)
      end
    end

    def status_values(statii, default:)
      enumerize(:status, in: statii, default: default)
      delegate(*statii.map { |s| :"#{s}?" }, to: :status)
      statii.each { |s| scope(s, -> { where(status: s)}) }
    end
  end

  private

  def assign_uniq_hash
    while uniq_hash.blank? || self.class.find_by(uniq_hash: uniq_hash).present?
      self.uniq_hash = SecureRandom.urlsafe_base64
    end
  end
end
