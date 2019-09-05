require_relative "happy_bird_pipes"
require_relative "bird"
require_relative "settings"
require_relative "main_menu"
require_relative "end_screen"
require "tty-reader"
require "curses"

include Curses

def draw_to_screen(screen, y, x, str)
    screen[y] = "" if !screen[y] # create row
    screen[y][x..x+str.length-1] = str
end

def read_from_screen(screen, y, x_range)
    return screen[y][x_range]
end

def draw_pipes(settings, pipes, pipe_offset, screen)
    s = settings
    range = pipe_offset..(s[:DIST_BETWEEN_PIPES_X] * (pipes.length - 1) + pipe_offset)
    s[:SCREEN_HEIGHT].times do |i| # each row
        this_row = ""
        pipes.each do |pipe|
            if !pipe || (i > pipe.top_height && i < pipe.bottom_head) # pipe gap
                this_row += s[:PIPE_GAP].center(s[:DIST_BETWEEN_PIPES_X], " ")
            elsif i == pipe.top_height || i == pipe.bottom_head # pipe head
                this_row += s[:PIPE_HEAD].center(s[:DIST_BETWEEN_PIPES_X], " ")
            else # pipe body
                this_row += s[:PIPE_BODY].center(s[:DIST_BETWEEN_PIPES_X], " ")
            end
        end
        draw_to_screen(screen, i, 0, this_row[range]+"\n")
    end
end

def draw_bird(bird, screen, bird_graphic)
    draw_to_screen(screen, bird.y_pos, bird.x_pos, bird_graphic)
end

def draw_score(screen, y, x, score)
    draw_to_screen(screen, y, x, "SCORE: #{score}")
end

def render(screen, window)
    window.clear
    screen.each do |row|
        window.addstr(row)
    end
    window.refresh
end

def game_start(settings)

    s = settings

    # curses
    init_screen # prevent flicker
    noecho # hide user input

    # tty-reader
    reader = TTY::Reader.new # get input without pressing enter

    # game state vars
    game_running = false
    x_offset = 0
    screen = []
    score = 0

    # initialise pipes
    starter_pipe = Pipe.new(s[:STARTER_PIPE_HEIGHT], s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y])
    random_pipe = RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])
    pipes = [nil, starter_pipe, starter_pipe, random_pipe]
    draw_pipes(s, pipes, x_offset, screen)

    # initialise bird
    #bird = Bird.new(2, 5, 0, s[:BIRD_JUMP_POW])
    bird = Bird.new(s[:BIRD_START_X], s[:BIRD_START_Y], 0, s[:BIRD_JUMP_POW])
    draw_bird(bird, screen, ":)")

    # initialise score
    screen_width = screen[0].length # length of any value in screen
    score_x_pos = screen_width - s[:SCORE_MARGIN] - 8 #rf
    score_y_pos = s[:SCREEN_HEIGHT] - s[:SCORE_MARGIN]
    draw_score(screen, score_y_pos, score_x_pos, score)

    # initialise screen
    win = Window.new(s[:SCREEN_HEIGHT], screen_width, 0, 0)
    win.nodelay = true # set listening for user input to nonblocking
    draw_to_screen(screen, s[:BIRD_START_Y] + 2, s[:BIRD_START_X], "[SPACE] to jump")
    render(screen, win)

    # start on spacebar press
    until reader.read_char == " "
      game_running = false
    end
    game_running = true
    bird.jump

    while game_running

        screen = []

        bird.jump if win.getch == " " # jump on space
        bird.move(s[:GRAVITY], s[:SCROLL_SPEED])
        
        # adjust x_offset
        case x_offset
        when s[:DIST_BETWEEN_PIPES_X] # first pipe off-screen
            x_offset = 0
            pipes.push(RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])).shift
        when (s[:DIST_BETWEEN_PIPES_X] - s[:PIPE_HEAD].length)/2 # player cleared pipe
            score += 1
        end
        x_offset += 1
        

        draw_pipes(s, pipes, x_offset, screen)
        draw_score(screen, score_y_pos, score_x_pos, score)

        # check for collision (when replaced range is not " ")
        hit = !read_from_screen(screen, bird.y_pos, bird.x_pos..bird.x_pos+s[:HAPPY_BIRD].length-1).match(" ")
        if hit # end game
            game_running = false
            draw_bird(bird, screen, s[:SAD_BIRD])
            # make bird red
            render(screen, win)
            sleep(s[:END_DELAY])
            end_screen(score)
            until reader.read_char == " "
                game_running = false
            end
            game_start(SETTINGS)
        else
            draw_bird(bird, screen, s[:HAPPY_BIRD])
            render(screen, win)
            sleep(s[:SCROLL_SPEED])
        end
    end
end

main_menu 

reader = TTY::Reader.new
until reader.read_char == " "
    game_running = false
end

game_start(SETTINGS)