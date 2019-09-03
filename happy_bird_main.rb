# graphics
pipe_head = "[|||||]"
pipe_body = " ||||| "
happy_bird = ":)"
sad_bird = ":("
ground = "_\n/"
test_line = "                   [||||]                                "
distance_between_pipes = 30
pipe_gap = 6
min_pipe_height = 2
game_height = 16
game_speed = 0.05 # move the screen five times a second

def update(screen_height)
    screen_height.times do
        puts "|====8"
    end
end


while test_line.length > 0
    system("clear")
    p(test_line)
    chars = test_line.chars
    chars.shift
    test_line = chars.join
    sleep(game_speed)
end