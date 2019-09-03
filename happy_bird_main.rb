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
game_speed = 0.5 # move the screen five times a second
game_running = true
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

starter_pipe = Pipe.new(5, game_height, pipe_gap_size)
random_pipe = RandomPipe.new(game_height, pipe_gap_size, min_pipe_height, max_pipe_height)
pipes = [nil, starter_pipe, starter_pipe, starter_pipe, random_pipe]

def update(game_height, pipes, pipe_gap, pipe_body, pipe_head, pipe_offset)
    # draw the screen
    system("clear")
    range = pipe_offset..(pipe_head.length * (pipes.length - 1) + pipe_offset)
    game_height.times do |i| # each row
        this_row = ""
        pipes.each do |pipe|
            if !pipe || (i > pipe.top_height && i < pipe.bottom_head) # no pipe exists - used for spacing out the start
                this_row += pipe_gap
            elsif i == pipe.top_height || i == pipe.bottom_head # render pipe head
                this_row += pipe_head
            else # render pipe body
                this_row += pipe_body
            end
        end
        p this_row[range]
    end
end

def game_start(game_height, pipes, pipe_gap, pipe_body, pipe_head, game_speed, min_pipe_height, max_pipe_height, pipe_gap_size)
    pipes = pipes
    game_running = true
    x_offset = 0
    while game_running
        update(game_height, pipes, pipe_gap, pipe_body, pipe_head, x_offset)
        # delay loop by game_speed
        sleep(0.05)
        if x_offset == pipe_head.length
            x_offset = 0
            p game_height, pipe_head.length, min_pipe_height, max_pipe_height
            pipes.push(RandomPipe.new(game_height, pipe_gap_size, min_pipe_height, max_pipe_height)).shift
        else
            x_offset += 1
        end
    end
end

game_start(game_height, pipes, pipe_gap, pipe_body, pipe_head, game_speed, min_pipe_height, max_pipe_height, pipe_gap_size)