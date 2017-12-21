class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates :cpf, :first_name, :surname, presence: true
  validates :cpf, uniqueness: { allow_nil: true }

  before_validation :fix_common_user_mistakes, on: :create

  def name
    "#{first_name} #{surname}"
  end

  def admin?
    true
  end

  private

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
