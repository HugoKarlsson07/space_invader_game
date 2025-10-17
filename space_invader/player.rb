class Player
  attr_accessor :score 
  attr_reader :x, :y, :level

  def initialize(x, y, score = 0)
    @image = Gosu::Image.new("media/img/anka.png")
    @death_sound = Gosu::Sample.new("media/sound/pling.mp3")
    @x = x
    @y = y
    @level = 1
    @score = score
    @lives = 3
    @speed = 12
  end

  def warp(x, y)
    @x = x
    @y = y
  end

  def turn_left
    @x -= @speed
  end

  def turn_right
    @x += @speed
  end

  def update
    max_x = 1600 - 125
    @x = max_x if @x + 115 >= 1600
    @x = 0 if @x <= 0

  end

  def draw
    @image.draw(@x, @y, 0, 0.6, 0.6)
  end
end