module FixturesToBet
  extend ActiveSupport::Concern

  included do
    before_action :get_fixtures_to_bet
  end

  protected

  def get_fixtures_to_bet
    if @user
      fixtures = @user.fixtures_to_bet
      if fixtures.any?
        days = fixtures.group_by{|f| f.day}.keys
        flash.now[:alert] = "You got #{fixtures.size} bets to place in #{days.map(&:name).join(", ")}."
      end
    end
  end
end
