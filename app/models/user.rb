# == Schema Information
# Schema version: 20110517043331
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :first_name, :last_name, :email, :password,
                  :password_confirmation

  has_many :created_tasks, :class_name => "Task", :foreign_key => "created_by_id"
  has_many :assigned_tasks, :class_name => "Task", :foreign_key => "assigned_to_id", :order => "position ASC"

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :first_name, :presence => true,
                         :length => { :maximum => 50 }
  validates :last_name, :presence => true,
                         :length => { :maximum => 50 }
  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    u = User.find_by_email(email)
    return nil if u.nil?
    return u if u.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  private
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{self.salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{self.password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
