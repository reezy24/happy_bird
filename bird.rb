class Bird
    attr_accessor :x_pos, :y_pos, :vel
    def initialize(x_pos, y_pos, vel)
        @x_pos = x_pos
        @y_pos = y_pos
        @vel = vel
    end
    def accelerate(a, t)
        @vel += a * t
    end
end