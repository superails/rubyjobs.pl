module ApplicationHelper
  def show_subscription_box?
    !cookies[:newsletter_subscription]
  end
end
