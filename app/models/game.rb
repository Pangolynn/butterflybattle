class Game < ActiveRecord::Base

#   set default game values
  def init
    self.p_score = 0
    self.p_loss_counter = 0
    self.level = 1
    player_stats
    self.p_last_move = 'None'
    self.npc_last_move = 'None'
    self.npc_win = FALSE
    self.p_win = FALSE
    self.retry = FALSE
    self.npc_bleed = FALSE
    self.p_bleed = FALSE



    save!
  end

  #Set player stats
  def player_stats
    self.p_max_health = 100 + self.level * 10
    self.p_max_armor = 100 + self.level * 10
    self.p_max_attack = 100 + self.level * 10
    self.p_max_speed = 100 + self.level * 10

    #The additional stat selected by user
    case self.p_stat_boost
      when 'Stamina'
        self.p_max_health += 10
      when 'Defense'
        self.p_max_armor += 10
      when 'Speed'
        self.p_max_speed += 10
      when 'Strength'
        self.p_max_attack += 10
      else
        puts "Not a possible Stat selection"
    end

    self.p_cur_health = self.p_max_health
    self.p_cur_armor = self.p_max_armor
    self.p_cur_attack = self.p_max_attack
    self.p_cur_speed = self.p_max_speed
    save!
  end

  #Used to access NPC Model Data to update the current NPC displayed and stats
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
    #Npc first
    if self.p_cur_speed < self.npc_cur_speed
      self.npc_first = TRUE
      ai_move
      #Check player health
      if self.p_cur_health <= 0
        self.npc_win = TRUE
        self.retry = TRUE
        self.p_loss_counter +=1
      else
        player_move(move_type)
        #Make sure the NPC hasn't already won since we can't stop
        #in between turns, Check NPC Health
        if self.npc_cur_health <= 0 && self.npc_win != TRUE
          self.p_win = TRUE
        end
      end
    #Player first
    else
      self.p_first = TRUE
      player_move(move_type)
      if self.npc_cur_health <= 0
        self.p_win = TRUE
      else
        ai_move
        if self.p_cur_health <= 0 && self.p_win != TRUE
          self.npc_win = TRUE
          self.retry = TRUE
          self.p_loss_counter +=1
        end
      end
    end
    save!  #update database
  end

  def player_move(move_type)
    #Check possible conditions before move
    if self.p_renew == TRUE
      self.p_cur_health += 6
      if self.p_cur_health > self.p_max_health
        self.p_cur_health = self.p_max_health
      end
      self.p_renew == FALSE
    end
    if self.p_bleed == TRUE
      self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.075) + 2
      self.p_bleed == FALSE
    end

    #Player lost a move, no attack
    if self.p_lose_turn == TRUE
      self.p_lose_turn = FALSE
      self.p_last_move = "No abilities"
    #Player is asleep
    elsif self.p_sleep == TRUE
      self.p_sleep = FALSE
      self.p_last_move = "zzZZzz"
     #Player is confused - hits self
    elsif self.p_confused == TRUE
      self.p_confused = FALSE
      self.p_last_move = "Confused"
      self.p_cur_health = self.p_cur_health - (self.p_cur_attack * 0.1)
      #Player forgot moves - can only normal attack
    elsif self.p_forget == TRUE
      self.p_forget = FALSE
      self.p_last_move = "Forgetful"
      self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.1) - (self.npc_cur_armor * 0.1) + 10

    elsif move_type == 'Attack'
      self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.1) - (self.npc_cur_armor * 0.1) + 10
      self.p_last_move = "Attack"
    elsif move_type == 'Defense'
      p_defense_move
      self.p_last_move = self.p_defense
    elsif move_type == 'Offense'
      p_offense_move
      self.p_last_move = self.p_offense
    else
      p_wild_move
      self.p_last_move = self.p_wild
    end
    save!
  end


  def p_defense_move
      if self.p_defense == "Renew"
        self.p_renew = TRUE
        self.p_cur_health += 10
        #Make sure they don't go over max health
        if self.p_cur_health > self.p_max_health
          self.p_cur_health = self.p_max_health
        end
      elsif self.p_defense == "Heal"
        self.p_cur_health += 15
        if self.p_cur_health > self.p_max_health
          self.p_cur_health = self.p_max_health
        end
      #Sleep - heals for a large amount, lose next turn
      else
        self.p_cur_health = self.p_cur_health + (self.p_max_health * 0.1) + 5
        self.p_sleep = TRUE
        if self.p_cur_health > self.p_max_health
          self.p_cur_health = self.p_max_health
        end
      end
  end

  #Offensive moves deal more damage when the enemy is below 25% health
  def p_offense_move
      #ignores some armor
      if self.p_offense == "Pummel"
        if self.npc_cur_health < self.npc_max_health * 0.25
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.15) - (self.npc_cur_armor * 0.05)
        else
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.05) - (self.npc_cur_armor * 0.05)
        end
       #takes recoil damage
      elsif self.p_offense == "Dive"
        if self.npc_cur_health < self.npc_max_health * 0.25
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.175) - (self.npc_cur_armor * 0.1) + 10
          self.p_cur_health = self.p_cur_health - (self.p_cur_attack * 0.1) - (self.p_cur_armor * 0.075) + 5
        else
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.1) - (self.npc_cur_armor * 0.1) + 5
          self.p_cur_health = self.p_cur_health - (self.p_cur_attack * 0.1) - (self.p_cur_armor * 0.075) + 5
        end
      #Poke - bleeds enemy
      else
        if self.npc_cur_health < self.npc_max_health * 0.25
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.175) - (self.npc_cur_armor * 0.1)
          self.npc_bleed == TRUE
        else
          self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.1) - (self.npc_cur_armor * 0.1) + 4
          self.npc_bleed == TRUE
        end
      end
  end

  #Wild Moves are more effective when the enemy is above 75% health
  def p_wild_move
    #Random chance to lose turn
    if self.p_wild == "Innocence"
      if self.npc_cur_health > self.npc_max_health * 0.75
        i = rand(1..5)
        if i == 1
          self.npc_lose_turn = TRUE
        end
      else
        i = rand(1..10)
        if i == 1
          self.npc_lose_turn = TRUE
        end
      end
      self.npc_cur_health = self.npc_cur_health - 5
    #Enemy may hit itself
    elsif self.p_wild == "Dazzle"
      if self.npc_cur_health > self.npc_max_health * 0.75
        i = rand(1..5)
        if i == 1
          self.npc_confused = TRUE
        end
      else
        i = rand(1..10)
        if i == 1
          self.npc_confused = TRUE
        end
      end
      self.npc_cur_health = self.npc_cur_health - 5
    #Whoosh - chance for enemy to forget attacks
    else
      if self.npc_cur_health > self.npc_max_health * 0.75
        i = rand(1..4)
        if i == 1
          self.npc_forget = TRUE
        end
      else
        i = rand(1..9)
        if i == 1
          self.npc_forget = TRUE
        end
      end
      self.npc_cur_health = self.npc_cur_health - 6
    end

  end

  def npc_defense_move
    #Heal over 2 turns
    if self.npc_defense == "Renew"
      self.npc_renew = TRUE
      self.npc_cur_health += 10
      if self.npc_cur_health > self.npc_max_health
        self.npc_cur_health = self.npc_max_health
      end
    #medium heal
    elsif self.npc_defense == "Heal"
      self.npc_cur_health += 15
      if self.npc_cur_health > self.npc_max_health
        self.npc_cur_health = self.npc_max_health
      end
      #Sleep
    else
      self.npc_cur_health = self.npc_cur_health + (self.npc_max_health * 0.1) + 5
      self.npc_sleep = TRUE
      if self.npc_cur_health > self.npc_max_health
        self.npc_cur_health = self.npc_max_health
      end
    end
  end

  def npc_offense_move
    if self.npc_offense == "Pummel"
      if self.p_cur_health < self.p_max_health * 0.25
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.15) - (self.p_cur_armor * 0.05)
      else
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.05) - (self.p_cur_armor * 0.05)
      end
    elsif self.npc_offense == "Dive"
      if self.p_cur_health < self.p_max_health * 0.25
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.175) - (self.p_cur_armor * 0.1) + 10
        self.npc_cur_health = self.npc_cur_health - (self.npc_cur_attack * 0.1) - (self.npc_cur_armor * 0.075) + 5
      else
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1) - (self.p_cur_armor * 0.1) + 5
        self.npc_cur_health = self.npc_cur_health - (self.npc_cur_attack * 0.1) - (self.npc_cur_armor * 0.075) + 5
      end
    #Poke
    else
      if self.p_cur_health < self.p_max_health * 0.25
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.175) - (self.p_cur_armor * 0.1)
        self.p_bleed == TRUE
      else
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1) - (self.p_cur_armor * 0.1)
        self.p_bleed == TRUE
      end
    end
  end

  def npc_wild_move
    if self.npc_wild == "Innocence"
      if self.p_cur_health > self.p_max_health * 0.75
        i = rand(1..5)
        if i == 1
          self.p_lose_turn = TRUE
        #Random chance to lose turn below 75%
        end
      else
        i = rand(1..10)
        if i == 1
          self.p_lose_turn = TRUE
        end
      end
      self.p_cur_health = self.p_cur_health - 5
    elsif self.npc_wild == "Dazzle"
      if self.p_cur_health > self.p_max_health * 0.75
        i = rand(1..5)
        if i == 1
          self.p_confused = TRUE
        end
      else
        i = rand(1..10)
        if i == 1
          self.p_confused = TRUE
        end
      end
      self.p_cur_health = self.p_cur_health - 5
      #Whoosh
    else
      if self.p_cur_health > self.p_max_health * 0.75
        i = rand(1..4)
        if i == 1
          self.p_forget = TRUE
        end
      else
        i = rand(1..9)
        if i == 1
          self.p_forget = TRUE
        end
      end
      self.p_cur_health = self.p_cur_health - 6
    end
  end

  def ai_move
      #Check possible conditions before move
      if self.npc_renew == TRUE
        self.npc_cur_health += 5
        self.npc_renew == FALSE
        if self.npc_cur_health > self.npc_max_health
          self.npc_cur_health = self.npc_max_health
        end
      end
      if self.npc_bleed == TRUE
        self.npc_cur_health = self.npc_cur_health - (self.p_cur_attack * 0.075) + 2
        self.npc_bleed == FALSE
      end

      if self.npc_lose_turn == TRUE
        self.npc_lose_turn = FALSE
        self.npc_last_move = "No abilities"

      elsif self.npc_sleep == TRUE
        self.npc_sleep = FALSE
        self.npc_last_move = "zzZZzz"

      elsif self.npc_confused == TRUE
        self.npc_confused = FALSE
        self.npc_last_move = "Confused"
        self.npc_cur_health = self.npc_cur_health - (self.npc_cur_attack * 0.1)

      elsif self.npc_forget == TRUE
        self.npc_forget = FALSE
        self.npc_last_move = "Forgetful"
        self.p_cur_health = self.p_cur_health - (self.npc_cur_attack * 0.1) - (self.p_cur_armor * 0.1) + 10

      elsif self.level < 3  #Level 1 and 2 should have silly AI
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
          npc_offense_move

        when 2
          self.npc_last_move = self.npc_defense.capitalize
          npc_defense_move

        when 3
          self.npc_last_move = self.npc_wild.capitalize
          npc_wild_move

        else
          print("Not a possible move")
      end
  end

    #Better AI
  def mediumai
    if self.npc_cur_health <= self.p_max_health * 0.25 &&
        self.npc_last_move != self.npc_defense
      #NPC should only use defense on low health
      self.npc_last_move = self.npc_defense
      npc_defense_move
    elsif self.p_cur_health > self.p_max_health * 0.80
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
    if self.npc_cur_health <= self.npc_max_health*0.25 &&
       self.p_cur_health > self.p_max_health * 0.4 &&
       self.npc_last_move != self.npc_defense
        self.npc_last_move = self.npc_defense
      npc_defense_move
    #NPC should use wild when opponent is high health
    #And NPC is not low health
    elsif self.p_cur_health > self.p_max_health * 0.75 &&
          self.npc_cur_health > self.npc_max_health*0.5
      self.npc_last_move = self.npc_wild
      npc_wild_move
    #NPC should use offense when opponent is low health
      #and NPC is not in danger of dying
    elsif self.p_cur_health < self.p_max_health * 0.25
      self.npc_last_move = self.npc_offense
      npc_offense_move
    #NPC should use attack when opponent is medium health
      #And NPC is not in danger of dying
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
        self.p_score = self.p_score + (self.level * 100) + ((self.p_cur_health/self.p_max_health)* 10)
        self.level += 1
        player_stats
        self.p_last_move = 'None'
        self.npc_last_move = 'None'
        self.npc_win = FALSE
        self.p_win = FALSE
      #Go to scoreboard if all levels defeated
      else
        self.npc_win = FALSE
        self.p_win = FALSE
        self.p_score = self.p_score + (self.level * 100) + ((self.p_cur_health/self.p_max_health)* 10)
        self.over = TRUE
      end
    #Player Lost Level, add to loss counter retry level
    elsif self.p_loss_counter < 2
      self.p_score -= 25
      self.p_loss_counter + 1
      player_stats
      self.retry = FALSE
      self.p_last_move = 'None'
      self.npc_last_move = 'None'
      self.npc_win = FALSE
      self.p_win = FALSE
    #Player Lost Game, go to scoreboard
    else
      self.npc_win = FALSE
      self.p_win = FALSE
      self.p_score -= 25
      self.over = TRUE
    end

    save!
  end


end
