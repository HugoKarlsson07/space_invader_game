require 'gosu'

WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 1000

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

    #if @y == enemy.y1 #då ska spelet sluta och texten you lose och vissa score
      
  end

  def draw
    @image.draw(@x, @y, 0, 0.6, 0.6)
  end
end

class Game < Gosu::Window
  attr_accessor :level, :speed

  def initialize
    super 1600, 1000
    self.caption = "Space Invader"

    @player = Player.new(750, 750)
    @player.warp(750, 750)

    

    @level = 1
    @speed = 0.4

    @bullets = []
    @enemies = []
    @enemy_bullets = []

    @enemy_direction = 1
    @last_click_time = Time.now - 1.0

    spawn_enemies
  end

  def spawn_enemies
    @enemies.clear
    rows = 5
    cols = 11
    x_spacing = 100
    y_spacing = 70
    start_x = 100
    start_y = 50

    rows.times do |row|
      cols.times do |col|
        x = start_x + col * x_spacing
        y = start_y + row * y_spacing
        @enemies << Enemy.new(self, x, y)
      end
    end
  end

  def update_speed(level)
    @speed = level*0.6 * 1.15**level
  end

  def implode
    @bullets.reject! do |bullet|
      hit_any = false
      @enemies.reject! do |enemy|
        hit = bullet.x.between?(enemy.x, enemy.x + 100) &&
              bullet.y.between?(enemy.y, enemy.y + 40)
        if hit
          hit_any = true
          @player.score+=1

        end
        hit
      end
      hit_any
    end
  end

  def update
    
    @player.turn_left if Gosu.button_down?(Gosu::KB_LEFT) || Gosu.button_down?(Gosu::GP_LEFT)
    @player.turn_right if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::GP_RIGHT)

  
    if Gosu.button_down?(Gosu::KB_UP) || Gosu.button_down?(Gosu::GP_BUTTON_0)
      cooldown = 0.1 # bullet coldown in sekonds
      if Time.now - @last_click_time >= cooldown
        @bullets << Bullet.new(@player.x + 50, @player.y)
        @last_click_time = Time.now
      end
    end

    @player.update

    @enemies.each { |enemy| enemy.update(@enemy_direction) }

    if @enemies.any? { |e| e.x <= 0 || e.x + 40 >= width }
      @enemy_direction *= -1
      @enemies.each(&:move_down)
    end

    if @enemies.empty?
      @level += 1
      update_speed(@level)
      spawn_enemies
      puts "spawn enemies, level #{@level}, score #{@player.score}"
    end

    @bullets.each(&:update)
    implode
    @bullets.reject! { |b| b.off_screen? }
  end

  def draw
    @player.draw
    @enemies.each(&:draw)
    @bullets.each(&:draw)
  end
end

Game.new.show
