require 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'enemy_bullet'


class Game < Gosu::Window
  attr_accessor :level, :speed  

  def initialize
    super 1600, 1000
    self.caption = "Space Invader"

    @player = Player.new(750, 750)
    @player.warp(750, 750)

    @death_sound = Gosu::Sample.new("media/sound/pling.mp3")
    @death_sound2 = Gosu::Sample.new("media/sound/coin.mp3")

    self.caption = "Text i Gosu"
    @font = Gosu::Font.new(32) # Skapa ett typsnitt med storlek 32
    @fonten = Gosu::Font.new(300)

    @level = 1
    @lives = 5

    @speed = 0.2


    @bullets = []
    @enemies = []
    @enemy_bullets = []

    @enemy_direction = 1
    @last_click_time = Time.now - 1.0
    @last_spawn_time = Time.now - 1.0
    @antal = @enemies.length

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

  def enemy_implode
    @enemy_bullets.reject! do |bullet|
      hit = bullet.x.between?(@player.x, @player.x + 100) && bullet.y.between?(@player.y, @player.y + 40)
      if hit
        @lives -= 1
      end
      hit
    end
  end

  def implode
    @bullets.reject! do |bullet|
      hit_any = false
      @enemies.reject! do |enemy|
        hit = bullet.x.between?(enemy.x, enemy.x + 100) &&
              bullet.y.between?(enemy.y, enemy.y + 40)
        if hit
          hit_any = true
          @player.score+=@level*2
          @speed += 0.025
          @death_sound.play
          @death_sound2.play
        end
        hit
      end
      hit_any
    end
  end

  def respawn
    if @enemies.empty?
      @player.warp(750, 750)
      if @last_death_time.nil?
        @last_death_time = Time.now
      elsif Time.now - @last_death_time >= 3
        @level += 1
        spawn_enemies
        @speed += 0.15
        @last_death_time = nil
      end
    end
  end

  def enemy_direction
    if @enemies.any? { |e| e.x <= 0 || e.x + 80 >= width }
      @enemy_direction *= -1
      @enemies.each(&:move_down)
    end
  end
  
  def enemy_shoot
    @enemies.each do |enemy|
      enemy.update(@enemy_direction)

      # Låt fiender slumpmässigt skjuta
      if rand(1..3000) == 1
        @enemy_bullets << Enemy_bullet.new(enemy.x + 40, enemy.y + 40)
      end
    end
  end

  def enemy_update
    @enemy_bullets.each(&:update)
  end

  def bullets_update
    @bullets.each(&:update)
  end

  def delete_off_screan
    @bullets.reject! { |b| b.off_screen? }
    @enemy_bullets.reject! { |b| b.off_screen? }
  end

  def player_shoot_button
    if Gosu.button_down?(Gosu::KB_UP) || Gosu.button_down?(Gosu::KB_SPACE) || Gosu.button_down?(Gosu::KB_W)
      cooldown = 0.1 # bullet coldown in sekonds
      if Time.now - @last_click_time >= cooldown
        @bullets << Bullet.new(@player.x + 50, @player.y)
        @last_click_time = Time.now
      end
    end
  end

  def update
    
    @player.turn_left if Gosu.button_down?(Gosu::KB_LEFT) || Gosu.button_down?(Gosu::KB_A)
    @player.turn_right if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu.button_down?(Gosu::KB_D)

    

    @player.update


    #kallarpå funktioner
    enemy_direction
    enemy_shoot
    respawn
    enemy_update
    bullets_update
    implode
    enemy_implode
    player_shoot_button
  end

  def draw
    @player.draw
    @enemies.each(&:draw)
    @bullets.each(&:draw)
    @enemy_bullets.each(&:draw)
    @font.draw_text("Score #{@player.score}", 100, 30, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @font.draw_text("Level #{@level}", 700, 30, 1, 1.0, 1.0, Gosu::Color::WHITE)
    @font.draw_text("Lives #{@lives}", 1300, 30, 1, 1.0, 1.0, Gosu::Color::WHITE)

  end
end

Game.new.show
