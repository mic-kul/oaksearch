class User < ActiveRecord::Base
	attr_accessor :password
	EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	validates :nick, :presence => true, :uniqueness => true, :length => { :in => 4..20 }
	validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :zip_code, :presence => true, :length => {:in => 1..10}
	validates :password, :confirmation => true, :on=>:create #password_confirmation attr
	validates_length_of :password, :in => 8..20, :on=>:create

    self.table_name = 'USERS'
    #self.primary_key = 'USER_ID'
    self.sequence_name = 'USER_ID_SEQ'
    before_save :hash_password
	after_save :clear_password

	has_many :reviews
	has_many :userwatchedproducts

	def hash_password
	  if password.present?
	    self.password_salt = BCrypt::Engine.generate_salt
	    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
	  end
	end

	def clear_password
	  #clear in-memory
	  self.password = nil
	end

	def self.authenticate(nick_or_email="", password_input="")
		if EMAIL_REGEX.match(nick_or_email)    
			user = User.find_by_email(nick_or_email)
		else
			user = User.find_by_nick(nick_or_email)
		end
		if user && user.match_password(password_input)
			return user
		else
			return false
		end
	end

	def match_password(password_input="")
		password_hash == BCrypt::Engine.hash_secret(password_input, password_salt)
	end

end
