class User < ActiveRecord::Base
  has_secure_password
  
  def deposit(amount)
    self.balance += amount
    self.save
  end
  
  def withdraw(amount)
    if amount <= self.balance
      self.balance -= amount
      self.save
    end
  end
end
