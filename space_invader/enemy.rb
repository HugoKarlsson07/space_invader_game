class Enemy
  def initialize(x,y)
    @Image = Gosu::Image.new("media/img/download.jpg")
    @live = 1
    @x = x
    @y = y
  
  def update
  end

  def draw
    @Image.draw(@x,@y)
  end


  end
end
