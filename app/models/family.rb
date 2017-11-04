class Family < ApplicationRecord
  has_many :items, dependent: :destroy
  validate :name,:email,:phone,:name_length,:phone_length,:city,:address,:address_info
  def self.available
    select{ |f| f.notTaken }
  end
  def self.needs
    select{ |f| !f.notTaken and !f.recieved }
  end
  def self.isMine user_id
    select{ |f| f.mine user_id}
  end
  def self.isRecieved
    select{ |f| f.recieved }
  end
  def areMineRecieved donor
    self.items.isMine(donor).each do |i|
      if i.recieved != true
        return false
      end
    end
    return true
  end
  def recieved
    items.each do |i|
      if i.recieved != true
        return false
      end
    end
    return true
  end
  def myCost user_id
    tot = 0
    items.each do |i|
      if i.user_id == user_id
        tot +=i.totalCost
      end
    end
    return tot
  end
  def self.notTaken
    items.each do |i|
      if i.user_id == nil
        return true
      end
    end
    return false
  end
  def mine user_id
    items.each do |i|
      if i.user_id == user_id
        return true
      end
    end
    return false
  end
  def self.mine user_id
    items.each do |i|
      if i.user_id == user_id
        return true
      end
    end
    return false
  end
  def notTaken
    items.each do |i|
      if i.user_id == nil
        return true
      end
    end
    return false
  end
  def self.cheapest
    order("cost ASC")
  end
  def self.expensive
    order("cost DESC")
  end
  def self.mostItems
    order("left DESC")
  end
  def self.leastItems
    order("left ASC")
  end
  def name_length
    if name != nil
      if name.length < 3
        errors.add(:name,"Name Must be atleast 3 characters long")
      end
    else
      errors.add(:name,"Name Must be atleast 3 characters long")
    end
  end
  def phone_length
    if phone != nil
      if phone.length != 10
        errors.add(:phone,"Phone number must have 9 digits.")
      end
    else
      errors.add(:phone,"Phone number must have 9 digits.")
    end
  end
  def address_info
    if address == "" || city == ""
      errors.add(:address,"Must Provide City and Address.")
    end
  end
end
