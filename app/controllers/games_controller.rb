class GamesController < ApplicationController
  def index
  end

  def new
  end

def update
  @games = Game.all
  id = session[:session_id]
  @game = Game.find_by(userID: id)
  @game.taketurn
  render :action => 'update'

end


def create
  @game = Game.new(game_params)
  @game.setid(session[:session_id])
  @game.init
  @game.save
  render 'update'
end

private
  def game_params
    params.require(:game).permit(:pName)
  end

end
