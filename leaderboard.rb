class Leaderboard
  def initialize
    @board = {
        John: 1,
        Zach: 2,
        Mary: 3
    }
  end
  def to_screen
    return @board.sort_by {|k, v| -v}.to_h
  end
end
