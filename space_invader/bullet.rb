


class Bullet
  attr_reader :x2, :y2 
  def initialize(x, y)
    @x2 = x
    @y2 = y
    @radius = 5   
    @speed = 8    
    
  end

  def update
    @y2 -= @speed
  end

  def draw
    Gosu.draw_rect(@x2 - @radius, @y2 - @radius,@radius * 2, @radius * 2,Gosu::Color::WHITE, 1)
  end

  def off_screen?(height)
    @y2 < 0
  end
end