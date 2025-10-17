class Enemy_bullet
  attr_reader :x, :y, :radius

  def initialize(x, y)
    @x = x
    @y = y
    @radius = 8
    @speed = 3
  end

  def update
    @y += @speed  # flyger neråt
  end

  def draw
    Gosu.draw_rect(@x - @radius, @y - @radius, @radius * 2, @radius * 2, Gosu::Color::RED, 1)
  end

  def off_screen?
    @y > 1000 # y > fönsterhöjd
  end
end