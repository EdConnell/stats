class GameSessionController < ApplicationController
  def show
    @gamesession = GameSession.find(params[:id])
  end
  def create
    @gamesession = GameSession.create
    redirect_to :action => show, :id => @gamesession
  end
  def list
    @gamesessions = GameSession.find(:all)
  end
  def new
    @gamesession = GameSession.new
  end
end
