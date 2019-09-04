require "test/unit"
require_relative "happy_bird_main"

class HappyBirdTest < Test::Unit::TestCase
    def setup
        @pipe = Pipe.new(5, 16, 6)
        @pipe_random = RandomPipe.new(16, 6, 2, 8)
        @bird = Bird.new(0, 5, 0)
    end
    def test_pipe
        assert_equal(5, @pipe.top_height)
        assert_equal(5, @pipe.bottom_height)
        assert_equal(11, @pipe.bottom_head)
    end
    def test_pipe_random
        assert(@pipe_random.top_height >= 2 && @pipe_random.top_height <= 8)
        assert(@pipe_random.bottom_height >= 2 && @pipe_random.bottom_height <= 8)
        assert(@pipe_random.bottom_height >= 8 && @pipe_random.bottom_height <= 14)
    end
    def test_bird
        assert_equal(0, @bird.x_pos)
    end
end

