class Bird
    attr_accessor :x_pos, :y_pos, :vel
    def initialize(x_pos, y_pos, vel, jump_vel)
        @x_pos = x_pos
        @y_pos = y_pos
        @vel = vel
        @jump_vel = jump_vel
    end
    def accelerate(a, t)
        @vel += a * t
    end
    def move(a, t)
        accelerate(a, t)
        @y_pos += @vel * t
    end
    def jump
        @vel = @jump_vel
    end
end