require 'gosu'

class Enemy
  attr_reader :x1, :y1 
  def initialize(x, y)
    @Image = Gosu::Image.new("media/img/creep.png")
    @death_sound = Gosu::Sample.new("media/sound/pling.mp3") 
    @lives = 1
    @radius = 40
    @x1 = x
    @y1 = y
  end

  def spawn(x,y)
    @x1 = x
    @y1 = y
  end

  def update

  end

  def draw
    @Image.draw(@x1, @y1,0,0.4,0.4)
  end

end


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


class Game < Gosu::Window
  def initialize
    super 1600, 1000
    self.caption = "space inavder"
    @level = 1
    @player = Player.new(750,750)
    @player.warp(750,750)
    @bullets = []
    @scoure = 0


    @enemys = []
    spawn_enemies
    
    
  end

  def enemy_movment
    if x1 == 800
      x1 = 50
      y1 += 50
    end
  end

  def spawn_enemies_dynamic
    sum = 5/@level
    cooldown = 1.3*sum

    @last_click_time ||= Time.now - cooldown
    if Time.now - @last_click_time >= cooldown
      @enemys << Enemy.new(x1,y1)
      @last_click_time = Time.now
    end
   
  end

  def levelels 
    if  @score > 
  end


  def spawn_enemies
      (13 * @level).times do |i|
      x1 = 50 + (i % 16) * 100
      y1 = 50 + (i / 16) * 80
      @enemys << Enemy.new(x1, y1)
      end
  end


  def implode
    @bullets.each do |bullet|
      @enemys.reject! do |enemy|
        dx = bullet.instance_variable_get(:@x2) - enemy.x1
        dy = bullet.instance_variable_get(:@y2) - enemy.y1
        Math.sqrt(dx*dx + dy*dy) < enemy.instance_variable_get(:@radius) + 3
        @score += 30
      end
    end
  end

  def update
    if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
      @player.turn_left
    end
    if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
      @player.turn_right
    end
    if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_1
      @player.no_move
    end
    
    if Gosu.button_down? Gosu::KB_UP or Gosu.button_down? Gosu::GP_BUTTON_0
      cooldown = 1.5   # seconds

      @last_click_time ||= Time.now - cooldown
      if Time.now - @last_click_time >= cooldown
        @bullets << Bullet.new(@player.x + 50, @player.y)
        @last_click_time = Time.now
      end
    end
    @player.update

    @bullets.each(&:update)
    implode
    @bullets.reject! { |bullet| bullet.off_screen?(height) }
  end

  def draw
    @player.draw
    @enemys.each(&:draw)
    @bullets.each(&:draw)
  end

end


spel = Game.new.show

