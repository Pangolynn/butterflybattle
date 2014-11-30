class GamesController < ApplicationController
  def index
  end

  def new
  end

def update

  @games = Game.all
  id = session[:session_id]
  @game = Game.find_by(userID: id)

  #Win/Lose Update Battlefield
  if params[:option] == 'Decision'
    level = @game.level + 1
    @npc = Npc.find_by(level: level)
    @game.update_npc(@npc.npc_name, @npc.npc_file, @npc.npc_wild, @npc.npc_offense,
                    @npc.npc_defense, @npc.npc_max_health, @npc.npc_max_armor,
                    @npc.npc_max_attack, @npc.npc_max_speed)
    @game.continue
  #What attack was pressed
  elsif params[:option] == 'Attack'
    @game.taketurn('Attack')
  elsif params[:option] == 'Defense'
    @game.taketurn('Defense')
  elsif params[:option] == 'Offense'
    @game.taketurn('Offense')
  else
    @game.taketurn('Wild')

  end
  render :action => 'update'

end



def create
  @game = Game.new(game_params)
  @game.setid(session[:session_id])
  @game.init
  #Level 1 enemy
  @npc = Npc.find_by(level: 1)
  @game.update_npc(@npc.npc_name, @npc.npc_file, @npc.npc_wild, @npc.npc_offense,
                  @npc.npc_defense, @npc.npc_max_health, @npc.npc_max_armor,
                  @npc.npc_max_attack, @npc.npc_max_speed)
  @saved = @game.save

  render 'update'
end

private
  def game_params
    params.require(:game).permit(:p_name, :p_color, :p_wild, :p_defense, :p_offense, :p_stat_boost)
  end

end
