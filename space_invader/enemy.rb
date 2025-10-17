class Enemy
  attr_reader :x, :y, :radius

  def initialize(game, x, y, speed = 0.4)
    @game = game
    @image = Gosu::Image.new("media/img/creep.png")
    @death_sound = Gosu::Sample.new("media/sound/pling.mp3")
    @lives = 1
    @radius = 40
    @x = x
    @y = y
    @speed = speed
  end


  def spawn(x, y)
    @x = x
    @y = y
  end

  def move_down
    @y += 40
  end

  def update(direction)
    # använder game.speed för att kunna påverka alla enemies från Game
    @x += @game.speed * direction
  end

  def draw
    @image.draw(@x, @y, 0, 0.4, 0.4)
  end
end
