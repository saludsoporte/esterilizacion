class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :rol, foreign_key: :rols_id
  def admin?
    self.rols_id == 1 ? true : false
  end
  def apellidos
    "#{apellido_p} #{apellido_m}".strip
  end
end
