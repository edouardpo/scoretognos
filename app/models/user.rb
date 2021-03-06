class User < ActiveRecord::Base
  obfuscate_id

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]
  has_many :user_scores
  has_many :championships, through: :user_scores

  def self.find_for_facebook_oauth(auth)
    user_params = auth.to_h.slice(:provider, :uid)
    user_params.merge! auth.info.slice(:email, :name)
    user_params[:facebook_picture_url] = auth.info.image
    user_params[:token] = auth.credentials.token
    user_params[:token_expiry] = Time.at(auth.credentials.expires_at)

    user = User.where(provider: auth.provider, uid: auth.uid).first
    user ||= User.where(email: auth.info.email).first # User did a regular sign up in the past.
    if user
      user.update(user_params)
    else
      user = User.new(user_params)
      user.password = Devise.friendly_token[0,20]  # Fake password for validation
      user.save!
    end

    return user
  end

  def has_joined championship
    user_scores.where(championship_id: championship.id).any?
  end

  def fixtures_to_bet
    fixtures = []
    user_scores.each do |us|
      bettable_fixtures = us.championship.fixtures.bettable
      bettable_fixtures_bet_on_by_us = us.bets.where(fixture: bettable_fixtures.map(&:id)).fixtures
      bettable_fixtures.all.each {|f| fixtures << f unless bettable_fixtures_bet_on_by_us.include?(f)}
    end
    fixtures
  end
end
