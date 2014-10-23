class Admin < ActiveRecord::Base
	attr_accessor :password
	EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i
	validates :nick, :presence => true, :uniqueness => true, :length => { :in => 4..20 }
	validates :email, :presence => true, :uniqueness => true, :format => EMAIL_REGEX
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :password, :confirmation => true, :on => "create" #password_confirmation attr
	validates_length_of :password, :in => 8..20, :on => "create"

    self.table_name = 'ADMINS'
    #self.primary_key = 'USER_ID'
    self.sequence_name = 'ADMIN_ID_SEQ'
    before_save :hash_password
	after_save :clear_password

	has_many :features
	has_many :products, :foreign_key => 'modified_by'
	has_many :products, :foreign_key => 'created_by'

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

	def match_password(password_input="")
		password_hash == BCrypt::Engine.hash_secret(password_input, password_salt)
	end

	def self.authenticate(username_or_email="", login_password="")
	  puts " > auth"
	  if  EMAIL_REGEX.match(username_or_email)    
	  	 puts " > auth 1"
	    user = Admin.find_by_email(username_or_email)
	  else
	  	 puts " > auth 2"
	    user = Admin.find_by_nick(username_or_email)
	  end
	  if user && user.match_password(login_password)
	  	 puts " > auth ok"
	    return user
	  else
	  	 puts " > auth false"
	    return false
	  end
	end   
	

end
