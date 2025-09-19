

class Player
  attr_reader :x, :y 
  def initialize(x,y)
    @Image = Gosu::Image.new("media/img/anka.png")
    @death_sound = Gosu::Sample.new("media/sound/pling.mp3") 
    @x = x
    @y = y
    @score = 0
    @lives = 3
  end
  
  def warp(x, y)
    @x = x
    @y = y
  end

  def turn_left
    @x -= 6
  end

  def turn_right
    @x += 6
  end

  def no_move
    @x += 0
  end


  def update
    if @x + 115 >= 1585
      @x =  1475
    end
    if @x  <= 0
      @x= 0
    end
  end

  def draw
    @Image.draw(@x, @y,0,0.6,0.6)
  end
end
