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
  end

  def join
    @user.user_scores.create!(championship: @championship)
    flash[:notice] = "La maman de Borie te souhaite la bienvenue dans le championnat #{@championship.name} !"
    redirect_to championship_path(@championship)
  end

  private

  def set_championship
    @championship = Championship.find(params[:id])
  end
end
