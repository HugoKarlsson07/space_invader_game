require 'gosu'
require_relative "enemy.rb"
require_relative "attack.rb"
require_relative "player.rb"
require_relative "booster.rb"



class Game < Gosu::Window
  def initialize
    super 1200, 800
    self.caption = "space inavder"
    @player = Player.new(600,800)
    
    
  end

  def update
    @player.update
  end

  def draw
    @player.draw
  end


end


spel = Game.new.show