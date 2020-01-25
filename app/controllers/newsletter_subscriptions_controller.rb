class NewsletterSubscriptionsController < ApplicationController
  def create
    @newsletter_subscription = NewsletterSubscription.find_or_initialize_by(newsletter_subscription_params)

    if @newsletter_subscription.persisted?
      flash[:notice] = 'Email już jest zapisany na listę'
      redirect_back(fallback_location: root_path) and return
    elsif @newsletter_subscription.save
      flash[:notice] = 'Dziękuję za zapisanie się, wkrótce powinieneś otrzymać maila z potwierdzeniem.'
      cookies[:newsletter_subscription] = true
      NewsletterMailer.with(email: @newsletter_subscription.email).confirm.deliver_later
    end

    redirect_back(fallback_location: root_path)
  end

  private

  def newsletter_subscription_params
    params.permit(:email)
  end
end
