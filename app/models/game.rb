class Game < ActiveRecord::Base

#   set default game values
def init
  self.p_max_health = 100
  self.p_cur_health = 100
  self.p_max_armor = 100
  self.p_cur_armor = 100
  self.p_cur_speed = 100
  self.p_cur_attack = 100
  self.p_max_speed = 100
  self.npc_cur_health = 100
  self.npc_cur_armor = 100
  self.npc_cur_attack = 100
  self.npc_name = "Cantankerous Caterpillar"
  self.npc_cur_speed = 100
  self.npc_max_speed = 100
  self.npc_max_attack = 100
  self.npc_max_armor = 100
  self.npc_max_health = 100
  self.npc_defense = 'Sleep'
  self.npc_offense = 'Pummel'
  self.npc_wild = 'Whoosh'
  self.level = 1
  self.p_last_move = 'None'
  self.npc_last_move = 'None'
  self.npc_win = FALSE
  self.p_win = FALSE

  #The additional stat selected by user
  case self.p_stat_boost
    when 'stamina'
      self.p_max_health += 10
    when 'defense'
      self.p_max_armor += 10
    when 'speed'
      self.p_max_speed += 10
    when 'strength'
      self.p_max_attack += 10
    else
      puts "Not a possible Stat selection"
  end

  case level
    when 1
      self.npc_name = "Cantankerous Caterpillar"
    when 2
      self.npc_name = "Mopey Moth"
    when 3
      self.npc_name = "Bossy Beetle"
    when 4
      self.npc_name = "Laughing Lady Bug"
    when 5
      self.npc_name = "Angry Ant"
    else
      self.npc_name = "No Enemy"
  end

end

# stores session ID , used to get players correct game table entry
def setid(id)
  self.userID = id
  save!

end


#take player turn, calls all AI helper functions
  def taketurn(move_type)
    if self.p_cur_speed < self.npc_cur_speed
      ai_move
      player_move
    else
      player_move
      ai_move
    end

    save!  #update database
  end

  def player_move
    #Attack
    self.npc_cur_health = self.npc_cur_health - self.p_cur_attack * 0.1
    - self.npc_cur_armor * 0.1 + 10
  end

  def ai_move
      if self.level < 2  #Level 1 and 2 should have silly AI
        lowai
      elsif self.level < 5  #Level 3-5 have more complicated AI
        mediumai
      else
        hardai
      end
  end




    #Silly AI
  def lowai
      i = rand(0..3)
      case i  #Return random move 1-4
        when 0
          #Attack
          self.npc_last_move = 'Attack'
          self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
          - (self.p_cur_armor * 0.1) + 10
        when 1
          self.npc_last_move = self.npc_offense.capitalize
          self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
          - (self.p_cur_armor * 0.1) + 10

        when 2
          self.npc_last_move = self.npc_defense.capitalize
          self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
          - (self.p_cur_armor * 0.1) + 10

        when 3
          self.npc_last_move = self.npc_wild.capitalize
          self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
          - (self.p_cur_armor * 0.1) + 10

        else
          print("Not a possible move")
      end
  end

    #Better AI
  def mediumai
    if self.npc_cur_health <= self.npc_max_health * 0.5
      #NPC should only use defense on low health
      self.npc_last_move = self.npc_defense
    elsif characterhealth > maxcharacterhealth * 0.75
      #NPC should use wild when opponent is high health
      self.npc_wild
    elsif characterhealth < maxcharacterhealth * 0.25
      self.npc_offense  #NPC should use offense when opponent is low health
    else
      #NPC should use attack when opponent is medium health
      self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
      - (self.p_cur_armor * 0.1) + 10
    end
  end

    #Best AI
  def hardai
    if currenthealth <= @maxhealth*0.5 && characterhealth > maxcharacterhealth * 0.25
      @abilities[2]  #NPC should only use defense on low health
      #And when the enemy can't be possibly killed
    elsif characterhealth > maxcharacterhealth * 0.75
      @abilities[3]  #NPC should use wild when opponent is high health
    elsif characterhealth < maxcharacterhealth * 0.25
      @abilities[1]  #NPC should use offense when opponent is low health
    else
      @abilities[0]  #NPC should use attack when opponent is medium health
    end
  end

  def testt
    self.p_cur_health = self.p_cur_health - 1
    save!
  end

end
