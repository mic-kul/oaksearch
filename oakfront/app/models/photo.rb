class Photo < ActiveRecord::Base

    self.table_name = 'PHOTOS'
    #self.primary_key = 'PRODUCT_ID'
    self.sequence_name = 'PHOTO_ID_SEQ'


  has_many :productphotos
  has_many :products, :through => :productphotos
  
def file_upload uploaded_file
	begin  
		file = Tempfile.new(uploaded_file, '/var/apps/oakfront/public/uploads')        
		returning File.open(file.path, "w") do |f|
		  f.write file.read
		  f.close
	end        
	ensure
		file.close
		file.unlink #remove temp
	end

end
end
