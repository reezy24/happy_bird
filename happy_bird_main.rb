require_relative "happy_bird_pipes"
require "tty-reader"
require "curses"
require_relative "bird"

#include Curses

SETTINGS = {
    
    #config
    SCREEN_HEIGHT: 20,
    DIST_BETWEEN_PIPES_X: 25,
    DIST_BETWEEN_PIPES_Y: 6,
    MIN_PIPE_HEIGHT: 2,
    SCROLL_SPEED: 0.05,
    STARTER_PIPE_HEIGHT: 5,

    #graphics
    PIPE_HEAD: "[|||||]",
    PIPE_BODY: " ||||| ",
    PIPE_GAP:  "       ",
    HAPPY_BIRD: ":)",
    SAD_BIRD: ":(",

}

# bird code to be placed in function
# bird_y = bird.y_pos.round
# bird_y.times do |i|
#     if i == bird_y
#         Curses.addstr(":)")
#     else
#         Curses.addstr("\n")
#     end
# end
# Curses.addstr(bird.y_pos.to_s) # debug

def draw_to_screen(screen, x, y, str)
    row = screen[y]
    row[x..str.length] = str
end

def draw_pipes(settings, pipes, pipe_offset, screen)
    s = settings
    range = pipe_offset..(s[:DIST_BETWEEN_PIPES_X] * (pipes.length - 1) + pipe_offset)
    s[:SCREEN_HEIGHT].times do |i| # each row
        this_row = ""
        pipes.each do |pipe|
            if !pipe || (i > pipe.top_height && i < pipe.bottom_head) # no pipe exists - used for spacing out the start
                this_row += s[:PIPE_GAP].center(s[:DIST_BETWEEN_PIPES_X], " ")
            elsif i == pipe.top_height || i == pipe.bottom_head # render pipe head
                this_row += s[:PIPE_HEAD].center(s[:DIST_BETWEEN_PIPES_X], " ")
            else # render pipe body
                this_row += s[:PIPE_BODY].center(s[:DIST_BETWEEN_PIPES_X], " ")
            end
        end
        Curses.addstr(this_row[range]+"\n")
    end
    bird_y = bird.y_pos.round
    bird_y.times do |i|
        if i == bird_y
            Curses.addstr(":)")
        else
            Curses.addstr("\n")
        end
    end
    Curses.refresh
end

# duplicate of draw_pipes atm
def render(screen)
    s = settings
    Curses.clear
    range = pipe_offset..(s[:DIST_BETWEEN_PIPES_X] * (pipes.length - 1) + pipe_offset)
    s[:SCREEN_HEIGHT].times do |i| # each row
        this_row = ""
        pipes.each do |pipe|
            if !pipe || (i > pipe.top_height && i < pipe.bottom_head) # no pipe exists - used for spacing out the start
                this_row += s[:PIPE_GAP].center(s[:DIST_BETWEEN_PIPES_X], " ")
            elsif i == pipe.top_height || i == pipe.bottom_head # render pipe head
                this_row += s[:PIPE_HEAD].center(s[:DIST_BETWEEN_PIPES_X], " ")
            else # render pipe body
                this_row += s[:PIPE_BODY].center(s[:DIST_BETWEEN_PIPES_X], " ")
            end
        end
        Curses.addstr(this_row[range]+"\n")
    end
    bird_y = bird.y_pos.round
    bird_y.times do |i|
        if i == bird_y
            Curses.addstr(":)")
        else
            Curses.addstr("\n")
        end
    end
    Curses.refresh
end

def game_start(settings)

    Curses.init_screen # prevent flicker
    Curses.noecho # hide user input

    s = settings

    # game state vars
    game_running = false
    x_offset = 1
    reader = TTY::Reader.new
    screen = []

    # initialise pipes
    starter_pipe = Pipe.new(s[:STARTER_PIPE_HEIGHT], s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y])
    random_pipe = RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])
    pipes = [nil, starter_pipe, starter_pipe, random_pipe]

    # initialise bird
    bird = Bird.new(0, 5, 0, -20)

    # draw screen but don't start moving yet
    update(s, pipes, 0, bird)
    until reader.read_char == " "
      game_running = false
    end
    game_running = true

    while game_running
        bird.jump if bird.y_pos >= 10
        bird.move(50, 0.05)
        update(s, pipes, x_offset, bird)
        # delay loop by game_speed
        sleep(0.05)
        if x_offset == s[:DIST_BETWEEN_PIPES_X]
            x_offset = 0
            pipes.push(RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])).shift
        else
            x_offset += 1
        end
        #reader.read_char
    end
end

game_start(SETTINGS)