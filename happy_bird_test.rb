require "test/unit"
require_relative "happy_bird_pipes"
require_relative "bird"
require_relative "leaderboard"

class HappyBirdTest < Test::Unit::TestCase
    def setup
        @pipe = Pipe.new(5, 16, 6)
        @pipe_random = RandomPipe.new(16, 6, 2)
        # @bird = Bird.new(0, 5, 0)
        @leaderboard = Leaderboard.new
    end
    def test_pipe
        assert_equal(5, @pipe.top_height)
        assert_equal(5, @pipe.bottom_height)
        assert_equal(11, @pipe.bottom_head)
    end
    def test_pipe_random
        assert(@pipe_random.top_height >= 2 && @pipe_random.top_height <= 8)
        assert(@pipe_random.bottom_height >= 2 && @pipe_random.bottom_height <= 8)
        #assert(@pipe_random.bottom_height >= 8 && @pipe_random.bottom_height <= 14)
    end
    # def test_bird
    #     assert_equal(0, @bird.x_pos)
    #     assert_equal(5, @bird.y_pos)
    #     assert_equal(0, @bird.vel)
    #     @bird.accelerate(2, 1)
    #     assert_equal(2, @bird.vel)
    # end
    def test_leaderboard
      assert_equal({
          John: 1,
          Zach: 2,
          Mary: 3
      }, @leaderboard.board)
      assert_equal([
        [:Mary, 3],
        [:Zach, 2],  
        [:John, 1]
      ], @leaderboard.to_screen)
      @leaderboard.new_entry(:Jack, 4)
      assert_equal({
          John: 1,
          Zach: 2,
          Mary: 3,
          Jack: 4,
      }, @leaderboard.board)
    end
end
