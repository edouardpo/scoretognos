module SetUser
  extend ActiveSupport::Concern

  included do
    before_action :set_user!
  end

  protected

  def set_user!
    @user = current_user if user_signed_in?
  end
end
