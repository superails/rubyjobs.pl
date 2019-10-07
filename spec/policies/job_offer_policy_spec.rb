require 'rails_helper'

RSpec.describe JobOfferPolicy, type: :policy do
  subject {JobOfferPolicy}

  let(:admin) {create(:user, admin: true)}
  let(:not_admin) {create(:user, admin: false)}
  let(:published_job_offer) {create(:job_offer, published_at: Time.zone.now)}
  let(:unpublished_job_offer) {create(:job_offer, published_at: nil)}

  permissions :publish? do
    it "denies access if job offer is published" do
      expect(subject).to_not permit(admin, published_job_offer)
    end

    it "denies access if user is not an admin" do
      expect(subject).to_not permit(not_admin, unpublished_job_offer)
    end

    it "grants access if user is admin and job offer is not published" do
      expect(subject).to permit(admin, unpublished_job_offer)
    end
  end
end
