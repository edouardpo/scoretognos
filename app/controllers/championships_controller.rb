class ChampionshipsController < ApplicationController
  before_action :set_championship, except: [:index]

  def index
    @championships = Championship.all
  end

  def show
    unless @user.has_joined(@championship)
      flash[:alert] = "You must follow this chamionship to access it !"
      redirect_to championships_path
    end
    @players_user_scores = @championship.user_scores.order(value: :desc)
  end

  def join
    @user.user_scores.create!(championship: @championship)
    flash[:notice] = "Mrs. Borie wants to welcome you with the warmest hug you ever had !"
    redirect_to championship_path(@championship)
  end

  private

  def set_championship
    @championship = Championship.find(params[:id])
  end
end
