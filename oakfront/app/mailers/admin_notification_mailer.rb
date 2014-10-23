class AdminNotificationMailer < ActionMailer::Base
  default from: "oakfront@example.com"

  def shop_inquiry(from, message)
  	admins = Admin.all
    admins.each do |admin|
    	mail(to: admin.email, subject: 'Shop Inquiry')
  end
end
