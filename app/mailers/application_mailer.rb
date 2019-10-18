class ApplicationMailer < ActionMailer::Base
  default from: 'mdoliwa@gmail.com', reply_to: 'mdoliwa@gmail.com'
  layout 'mailer'
end
