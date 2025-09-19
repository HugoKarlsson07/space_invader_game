


class Player
  def initialize(x,y)
    @Image = Gosu::Image.new("media/img/download.jpg")
    @death_sound = Gosu::Sample.new("media/sound/pling.mp3") 

    @lives = 3
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.turn_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.turn_right
    end
  end

  def draw
    @Image.draw(@x, @y, 0, 0.6, 0.6)
  end
end
