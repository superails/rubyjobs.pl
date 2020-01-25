class NewsletterSubscriptions::ConfirmationsController < ApplicationController
  def create
    @newsletter_subscription = NewsletterSubscription.find_by(confirm_token: params[:confirm_token])

    redirect_to root_path and return if @newsletter_subscription.confirmation_sent_at

    if @newsletter_subscription.update(state: 'confirmed', confirmation_sent_at: Time.zone.now)
      flash[:notice] = 'Dziękuję za potwierdzenie subskrypcji.'
      NewsletterMailer.with(email: @newsletter_subscription.email).welcome.deliver_later
    end

    redirect_to root_path
  end
end
