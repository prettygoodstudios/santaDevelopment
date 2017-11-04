class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :name, :phone
  has_many :items, dependent: :nullify

  def self.donor
    select { |u| u.is_donor}
  end
  def is_donor
    items.each do |i|
      if i.user_id != nil
        return true
      end
    end
    return false
  end
  def first_name
      self.name.split.first
  end
  def last_name
     self.name.split.last
  end
  def is_admin
    self.admin
  end
end
