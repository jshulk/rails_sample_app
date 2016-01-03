class User < ActiveRecord::Base
  attr_accessor :remember_token
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_save {self.email = email.downcase}
  
  has_secure_password
  validates :password, length: {minimum: 6 }, allow_blank: true
  
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 250}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  
  def User.digest(string) 
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    puts "user's remember digest - #{self.remember_digest}"
  end
  
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    result = BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
    puts "result - #{result}"
    return result
  end
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  
  
end
