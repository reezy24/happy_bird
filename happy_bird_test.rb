require "test/unit"
require_relative "happy_bird_main"

class HappyBirdTest < Test::Unit::TestCase
    def setup
        @pipe = Pipe.new(5, 16, 6)
    end
    def test_pipe
        assert_equal(5, @pipe.top_height)
    end
end

