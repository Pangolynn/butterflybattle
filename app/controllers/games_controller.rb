class GamesController < ApplicationController
  def index
  end

  def new
  end

def update

  @games = Game.all


  id = session[:session_id]
  @game = Game.find_by(userID: id)

  if params[:option] == 'Attack'
    @game.taketurn('Attack')
  end
  render :action => 'update'

end



def create
  @game = Game.new(game_params)
  @game.setid(session[:session_id])
  @game.init
  @saved = @game.save

  render 'update'
end

private
  def game_params
    params.require(:game).permit(:p_name, :p_color, :p_wild, :p_defense, :p_offense, :p_stat_boost)
  end

end
