class User < ApplicationRecord
  def self.permitted_params
    %i(email password password_confirmation first_name surname phone birth_date)
  end

  set_index_columns do |user|
    if user&.admin?
      %i(email first_name surname current_sign_in_at sign_in_count created_at)
    else
      []
    end
  end

  include RoleModel
  include Tokenable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :properties, inverse_of: :user
  has_many :sale_listings, through: :properties
  has_many :buy_visits, foreign_key: :buyer_id, class_name: 'Visit', inverse_of: :buyer
  has_many :sale_visits, foreign_key: :visitor_id, class_name: 'Visit', inverse_of: :visitor

  # validates :cpf, :first_name, :surname, presence: true
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

  private

  def set_default_role
    self.roles = [:seller] if self.roles.blank?
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
