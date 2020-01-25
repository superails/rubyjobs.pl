class NewsletterMailer < ApplicationMailer
  def confirm
    @subscription = NewsletterSubscription.find_by(email: params[:email])

    mail(to: params[:email], subject: 'RubyJobs.pl - potwierdź subskrypcję.')
  end

  def welcome
    @subscription = NewsletterSubscription.find_by(email: params[:email])

    mail(to: params[:email], subject: 'RubyJobs.pl - dziękuję za subskrypcję przeglądu ofert.')
  end
end
