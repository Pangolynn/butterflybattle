class Game < ActiveRecord::Base

#   set default game values
def init
  self.pHealth = 100
  self.pDefense = 100
  self.pDefenseAbility = 'Sleep'
  self.pOffenseAbility = 'Pummel'
  self.pWildAbility = 'Whoosh'
  self.pColor = 'black'
end

# stores session ID , used to get players correct game table entry
def setid(id)
  self.userID = id
  save!

end

  def lowerdefense
    self.pDefense = (self.pDefense - 2)
  end

#take player turn
  def taketurn
    self.pHealth = (self.pHealth - 1)
    lowerdefense
    save!
  end


end
