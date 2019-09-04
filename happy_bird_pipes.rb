class Pipe
    attr_accessor :top_height, :bottom_height, :bottom_head 
    def initialize(top_height, game_height, pipe_gap_size)
        @top_height = top_height
        @bottom_height = game_height - top_height - pipe_gap_size
        @bottom_head = game_height - @bottom_height
    end
end

class RandomPipe < Pipe
    def initialize(game_height, pipe_gap_size, min_pipe_height)
        max_pipe_height = game_height - pipe_gap_size - min_pipe_height
        top_height = rand(min_pipe_height..max_pipe_height)
        super(top_height, game_height, pipe_gap_size)
    end
end