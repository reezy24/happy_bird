# graphics
pipe_head = "[|||||]"
pipe_body = " ||||| "
pipe_gap =  "       "

happy_bird = ":)"
sad_bird = ":("

# game vars
game_height = 16
distance_between_pipes = 30
pipe_gap_size = 6
min_pipe_height = 2
max_pipe_height = game_height - pipe_gap_size - min_pipe_height
game_speed = 0.05 # move the screen five times a second
game_running = true
pipes_on_screen = 4
x_shift = 0
pipes = []

#modify pipe graphics based on distance_between_pipes
pipe_head = pipe_head.center(pipe_head.length + distance_between_pipes / 2, " ")
pipe_body = pipe_body.center(pipe_body.length + distance_between_pipes / 2, " ")
pipe_gap  = pipe_gap .center(pipe_gap .length + distance_between_pipes / 2, " ")

# function to generate random pipe boundaries
class Pipe
    attr_accessor :top_height, :bottom_height, :bottom_head 
    def initialize(top_height, game_height, pipe_gap_size)
        @top_height = top_height
        @bottom_height = game_height - top_height - pipe_gap_size
        @bottom_head = game_height - @bottom_height
    end
end

class RandomPipe < Pipe
    def initialize(game_height, pipe_gap_size, min_pipe_height, max_pipe_height)
        top_height = rand(min_pipe_height..max_pipe_height)
        super(top_height, game_height, pipe_gap_size)
    end
end

pipes = [nil, Pipe.new(5, game_height, pipe_gap_size), Pipe.new(5, game_height, pipe_gap_size), Pipe.new(5, game_height, pipe_gap_size)]

def update
    # draw the screen
    system("clear")
    game_height.times do |i| # each row
        pipe_heights.each do |height|
            # current height is equal to top or bottom pipe height - head
            # current height is between top or bottom pipe - gap
            # else - body
            if i == top_pipe_head or i == bottom_pipe_head
            end
            # wait
        end
        sleep(game_speed)
    end
end

def game_start
    game_running = true
    while game_running
        update
    end
end

#game_running