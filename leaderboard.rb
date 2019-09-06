class Leaderboard
  attr_accessor :board
  def initialize
    @board = { # dummy data
        REEZ: 999,
        ELON: 99,
        HAYLEY: 9
    }
  end
  def to_screen
    screen = []
    # sort the board in descending order and convert values to strings
    @board.sort_by {|k, v| -v}.each do |entry|
      name = entry[0].to_s
      score = entry[1].to_s
      screen.push("#{name}: #{score}\n")
    end
    return screen
  end
  def new_entry(name, score)
    @board[name] = score
  end
end
