class Game < ActiveRecord::Base

#   set default game values
  def init
    self.level = 1
    player_stats
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
    save!
  end

  #Set player stats
  def player_stats
    self.p_max_health = 100 + self.level * 10
    self.p_cur_health = 100 + self.level * 10
    self.p_max_armor = 100 + self.level * 10
    self.p_cur_armor = 100 + self.level * 10
    self.p_cur_speed = 100 + self.level * 10
    self.p_cur_attack = 100 + self.level * 10
    self.p_max_speed = 100 + self.level * 10
    save!
  end

  #Used to access NPC Model Data to update the current NPC display and stats
  def update_npc(npc_name, npc_file, npc_wild, npc_offense, npc_defense,
               npc_max_health, npc_max_armor, npc_max_attack, npc_max_speed)
    self.npc_max_armor = npc_max_armor + self.level * 10
    self.npc_max_attack = npc_max_attack + self.level * 10
    self.npc_max_health = npc_max_health + self.level * 10
    self.npc_max_speed = npc_max_speed + self.level * 10
    self.npc_name = npc_name
    self.npc_file = npc_file
    self.npc_wild = npc_wild
    self.npc_defense = npc_defense
    self.npc_offense = npc_offense
    self.npc_cur_armor = self.npc_max_armor
    self.npc_cur_speed = self.npc_max_speed
    self.npc_cur_health = self.npc_max_health
    self.npc_cur_attack = self.npc_max_attack
    save!
  end

# stores session ID , used to get players correct game table entry
  def setid(id)
    self.userID = id
    save!
  end


#take player turn, calls all AI helper functions
#To determine moves and winner
  def taketurn(move_type)
    #See who goes first
    if self.p_cur_speed < self.npc_cur_speed
      self.npc_first = TRUE
      ai_move
      #Check player health
      if self.p_cur_health <= 0
        self.npc_win = TRUE
        self.p_loss_counter +=1
      else
        player_move(move_type)
        #Make sure the NPC hasn't already won since we can't stop
        #in between turns, Check NPC Health
        if self.npc_cur_health <= 0 && self.npc_win != TRUE
          self.p_win = TRUE
        end
      end
    else
      self.p_first = TRUE
      player_move(move_type)
      if self.npc_cur_health <= 0
        self.p_win = TRUE
      else
        ai_move
        if self.p_cur_health <= 0 && self.p_win != TRUE
          self.npc_win = TRUE
          self.p_loss_counter +=1
        end
      end
    end
    save!  #update database
  end

  def player_move(move_type)
    if move_type == 'Attack'
    #Attack
    self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.1) - (self.npc_cur_armor * 0.1) + 10
    elsif move_type == 'Defense'
      p_defense_move
    elsif move_type == 'Offense'
      p_offense_move
    else
      p_wild_move
    end
    save!
  end

  def p_defense_move
      if self.p_defense == "Block"

      elsif self.p_defense == "Heal"

      #Sleep
      else

      end
  end

  #Offensive moves deal more damage when the enemy is below 25% health
  def p_offense_move
      if self.p_offense == "Pummel"
        if self.npc_cur_health < self.npc_max_health * 0.25
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.2) - (self.npc_cur_armor * 0.1) + 10
        else
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.15) - (self.npc_cur_armor * 0.1) + 10
        end
      elsif self.p_offense == "Dive"
        if self.npc_cur_health < self.npc_max_health * 0.25
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.25) - (self.npc_cur_armor * 0.1) + 10
          self.p_cur_health = self.p_cur_health - (self.p_cur_attack * 0.1) - (self.p_cur_armor * 0.1) + 5
        else
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.2) - (self.npc_cur_armor * 0.1) + 10
        end
      #Poke
      else
        self.lose_turn == TRUE


      end
  end

  #Wild Moves are more effect when the enemy is above 75% health
  def p_wild_move
    if self.p.wild == "Innocence"
    elsif self.p_wild == "Dazzle"
    #Whoosh
    else

    end

  end

  def npc_defense_move
    if self.npc_defense == "Block"

    elsif self.npc_defense == "Heal"

      #Sleep
    else

    end
  end

  def npc_offense_move
    if self.npc_offense == "Pummel"

    elsif self.npc_offense == "Dive"
      #Poke
    else

    end
  end

  def npc_wild_move
    if self.npc.wild == "Innocence"
    elsif self.npc_wild == "Dazzle"
      #Whoosh
    else

    end
  end

  def ai_move
      if self.level < 8  #Level 1 and 2 should have silly AI
        lowai
      elsif self.level < 5  #Level 3-5 have more complicated AI
        mediumai
      else
        hardai    #Level 6 and 7 should have best AI
      end
    save!
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
          # npc_offense_move

        when 2
          self.npc_last_move = self.npc_defense.capitalize
          # npc_defense_move

        when 3
          self.npc_last_move = self.npc_wild.capitalize
          # npc_wild_move

        else
          print("Not a possible move")
      end
  end

    #Better AI
  def mediumai
    if self.p_cur_health <= self.p_max_health * 0.5
      #NPC should only use defense on low health
      self.npc_last_move = self.npc_defense
      npc_defense_move
    elsif self.p_cur_health > self.p_max_health * 0.75
      #NPC should use wild when opponent is high health
      self.npc_last_move = self.npc_wild
      npc_wild_move
    elsif self.p_cur_health < self.p_max_health * 0.25
      self.npc_last_move = self.npc_offense  #NPC should use offense when opponent is low health
      npc_offense_move
    else
      #NPC should use attack when opponent is medium health
      self.npc_last_move = 'Attack'
          self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
                            - (self.p_cur_armor * 0.1) + 10
    end
  end

    #Best AI
  def hardai
    #NPC should only use defense on low health
    #And when the enemy can't be possibly killed
    if self.npc_cur_health <= self.npc_max_health*0.5 &&
          self.p_cur_health > self.p_max_health * 0.20
      self.npc_last_move = self.npc_defense
      npc_defense_move
    #NPC should use wild when opponent is high health
    elsif self.p_cur_health > self.p_max_health * 0.75
      self.npc_last_move = self.npc_wild
      npc_wild_move
    #NPC should use offense when opponent is low health
    elsif self.p_cur_health < self.p_max_health * 0.25
      self.npc_last_move = self.npc_offense
      npc_offense_move
    #NPC should use attack when opponent is medium health
    else
      self.npc_last_move = 'Attack'
      self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1)
      - (self.p_cur_armor * 0.1) + 10
    end
  end

  def continue
    #Player won
    if self.p_win
      #Go to next level if there is another
      if self.level < 7
        self.level += 1
        player_stats
        self.p_last_move = 'None'
        self.npc_last_move = 'None'
        self.npc_win = FALSE
        self.p_win = FALSE
      #Go to scoreboard if all levels defeated
      else
        go_to_highscore
      end
    #Player Lost Level, add to loss counter retry level
    elsif self.p_loss_counter < 1
      self.p_loss_counter + 1
      player_stats
      self.p_last_move = 'None'
      self.npc_last_move = 'None'
      self.npc_win = FALSE
      self.p_win = FALSE
    #Player Lost Game, go to scoreboard
    else
      go_to_highscore
    end

    save!
  end

  def go_to_highscore
    #put name and level in highscore table
  end

end
