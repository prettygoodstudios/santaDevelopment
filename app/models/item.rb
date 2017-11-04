class Item < ApplicationRecord
  belongs_to :family
  validate :quantity,:member,:age,:name,:cost,:more_zero,:name_length,:cost_zero,:member_age,:member_name,:description_length
  def self.available
    select { |i| i.user_id == nil }
  end
  def self.donated
    where.not(user_id: nil)
  end
  def self.isMine user_id
    select { |i| i.user_id == user_id }
  end
  def self.cheapest
    order("cost ASC")
  end
  def self.recieved
    where(recieved: true)
  end
  def more_zero
    if quantity != nil
      if quantity < 1
        errors.add(:quantity,"Quantity must be atleast 1.")
      end
    end
  end
  def name_length
    if name != nil
      if name.length < 2
        errors.add(:name,"Name must be atleast 2 characters long.")
      end
    end
  end
  def cost_zero
    if cost != nil
      if cost < 0.01
        errors.add(:cost,"Cost per unit must be atleast one cent.")
      end
    end
  end
  def member_age
    if age != nil
      if age < 1
        errors.add(:age,"Member age must be atleast 1 year old")
      end
    end
  end
  def member_name
    if member != nil
      if member.length < 2
        errors.add(:member,"Member name must be atleast 3 characters.")
      end
    end
  end
  def description_length
    if description == nil
      errors.add(:description,"You must have a description.")
    elsif description.length < 2
      errors.add(:description,"You must have a description.")
    end
  end
end
