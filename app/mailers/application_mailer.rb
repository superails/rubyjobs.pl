class ApplicationMailer < ActionMailer::Base
  default from: 'marcin@rubyjobs.pl', reply_to: 'marcin@rubyjobs.pl'
  layout 'mailer'
end
