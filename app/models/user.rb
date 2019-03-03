# frozen_string_literal: true

class User < ApplicationRecord
  permit_params do
    permit %i[email first_name surname phone birth_date]
    permit %i[cpf password] if create?
  end

  admin_index_columns do
    %i[email first_name surname current_sign_in_at sign_in_count created_at]
  end

  serialize_with(:email, :first_name, :surname, :phone,
                 :cpf, :birth_date, :roles,
                 :buy_visits, :sale_visits,
                 :properties, :favorite_listings)

  include RoleModel
  include Tokenable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :properties, foreign_key: :owner_id, class_name: 'Property', inverse_of: :owner
  has_many :listings, through: :properties
  has_many :buy_visits, foreign_key: :buyer_id, class_name: 'Visit', inverse_of: :buyer
  has_many :sale_visits, foreign_key: :visitor_id, class_name: 'Visit', inverse_of: :visitor
  has_many :user_favorite_listings, inverse_of: :user
  has_many :favorite_listings, through: :user_favorite_listings, source: :listing

  validates :cpf, :email, :encrypted_password, :first_name, :surname, presence: true
  validates :cpf, uniqueness: { allow_nil: true }
  attr_readonly :cpf

  before_validation :fix_common_user_mistakes, on: :create
  before_validation :set_default_role, on: :create

  roles :buyer, :seller, :visitor, :admin

  def name
    "#{first_name} #{surname}"
  end

  def name=(s)
    self.first_name, self.surname = (s || '').split(' ', 2)
  end

  def available?(at: _)
    true
  end

  class InvalidPassword < StandardError; end
  def validate_password!(password)
    raise InvalidPassword unless valid_password?(password)
  end

  def cpf=(value)
    self[:cpf] = self.class.normalized_cpf(value)
  end

  def formatted_cpf
    self.class.formatted_cpf(cpf)
  end

  def normalized_cpf
    self.class.normalized_cpf(cpf)
  end

  def self.normalized_cpf(cpf)
    cpf.scan(/\d/).join.rjust(11, '0') if cpf.present?
  end

  def self.formatted_cpf(cpf)
    return if (clean = normalized_cpf(cpf)).blank?

    "#{clean[0, 3]}.#{clean[3, 3]}.#{clean[6, 3]}-#{clean[9, 2]}"
  end

  private

  def set_default_role
    self.roles = [:buyer] if roles.blank?
  end

  def fix_common_user_mistakes
    if email.present?
      self.email = email.gsub(/\.(con|om)(\.br)?$/, '.com\2')
                        .gsub(/@gmail\.com\.br$/, '@gmail.com')
                        .gsub(/@g(a?mi|mei|msi|amai|mia)l\.com$/, '@gmail.com')
                        .gsub(/@hor?mail\.com$/, '@hotmail.com')
                        .gsub(/@(hot|g)(mal|mai|nail)\.com$/, '@\1mail.com')
    end
  end
end
