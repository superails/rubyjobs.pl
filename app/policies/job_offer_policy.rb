class JobOfferPolicy < ApplicationPolicy
  def publish?
    user.admin? && record.unpublished?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
