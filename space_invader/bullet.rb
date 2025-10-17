class Bullet
  attr_reader :x, :y, :radius

  def initialize(x, y)
    @x = x
    @y = y
    @radius = 5
    @speed = 8
  end

  def update
    @y -= @speed
  end

  def draw
    Gosu.draw_rect(@x - @radius, @y - @radius, @radius * 2, @radius * 2, Gosu::Color::WHITE, 1)
  end

  def off_screen?
    @y < 0
  end
end