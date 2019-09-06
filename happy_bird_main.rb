require_relative "happy_bird_pipes"
require_relative "bird"
require_relative "settings"
require_relative "main_menu"
require_relative "end_screen"
require_relative "leaderboard"
require_relative "game_options"

require "tty-reader"
require "curses"

include Curses

# curses
init_screen # prevent flicker
noecho
curs_set(0)
start_color
init_pair(1, COLOR_GREEN, COLOR_BLACK)
init_pair(2, COLOR_BLACK, COLOR_YELLOW)
init_pair(3, COLOR_WHITE, COLOR_BLACK)
init_pair(4, COLOR_BLACK, COLOR_RED)
win = Window.new(SETTINGS[:SCREEN_HEIGHT], 100, 0, 0)
win.nodelay = true # set listening for user input to nonblocking

leaderboard = Leaderboard.new

def range(lower, upper)
    return lower..lower + upper
end

def draw_to_screen(screen, y, x, str, win, pair = 3)
    screen[y] = "" if !screen[y] # create row
    screen[y][range(x, str.length-1)] = str
    win.attrset(color_pair(pair) | A_NORMAL)
    win.setpos(y,x)
    win.addstr(str)
end

def read_from_screen(screen, y, x_range)
    return screen[y][x_range]
end

def draw_pipes(settings, pipes, pipe_offset, screen, win)
    s = settings
    viewport = range(pipe_offset, s[:DIST_BETWEEN_PIPES_X] * (pipes.length - 1))
    s[:SCREEN_HEIGHT].times do |i| # each row
        this_row = ""
        pipes.each do |pipe|
            if i == s[:SCREEN_HEIGHT] - 1 # pipe ground
                this_row += s[:GROUND_FILL].center(s[:DIST_BETWEEN_PIPES_X], s[:GROUND_FILL][0])
            elsif i == 0
                this_row += s[:PIPE_TOP].center(s[:DIST_BETWEEN_PIPES_X], "_")
            elsif i == s[:SCREEN_HEIGHT] - 2 # pipe ground
                if pipe
                    this_row += s[:PIPE_GROUND].center(s[:DIST_BETWEEN_PIPES_X], "_")
                else
                    this_row += s[:PIPE_TOP].center(s[:DIST_BETWEEN_PIPES_X], "_")
                end
            elsif !pipe || (i > pipe.top_height && i < pipe.bottom_head) # pipe gap
                this_row += s[:PIPE_GAP].center(s[:DIST_BETWEEN_PIPES_X], " ")
            elsif i == pipe.top_height || i == pipe.bottom_head # pipe head
                this_row += s[:PIPE_HEAD].center(s[:DIST_BETWEEN_PIPES_X], " ")
            
            else # pipe body
                this_row += s[:PIPE_BODY].center(s[:DIST_BETWEEN_PIPES_X], " ")
            end
        end
        draw_to_screen(screen, i, 0, this_row[viewport]+"\n", win, 1)
    end
end

def draw_bird(bird, screen, bird_graphic, win, pair = 2)
    draw_to_screen(screen, bird.y_pos, bird.x_pos, bird_graphic, win, pair)
end

def draw_score(screen, y, x, score, win)
    draw_to_screen(screen, y, x, "SCORE: #{score}", win)
end

def render(screen, window)
    window.clear
    screen.each do |row|
        window.addstr(row)
    end
    window.refresh
end

def select_option(win, leaderboard, options)
    reader = TTY::Reader.new
    case reader.read_char
    when " "
        game_start(SETTINGS, win, leaderboard, options)
    when "l"
        render(leaderboard.to_screen + options, win)
        select_option(win, leaderboard, options)
    when "q"
        exit
    else
        select_option(win, leaderboard, options)
    end
end

def input_wait(input)
    reader = TTY::Reader.new
    input_wait(input) unless reader.read_char == input
end

def game_start(settings, win, leaderboard, options)

    s = settings

    # game state vars
    game_running = false
    x_offset = 0
    screen = []
    score = 0

    # initialise pipes
    starter_pipe = Pipe.new(s[:STARTER_PIPE_HEIGHT], s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y])
    random_pipe = RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])
    pipes = [nil, starter_pipe, starter_pipe, random_pipe]
    draw_pipes(s, pipes, x_offset, screen, win)

    # initialise bird
    bird = Bird.new(s[:BIRD_START_X], s[:BIRD_START_Y], 0, s[:BIRD_JUMP_POW])
    draw_bird(bird, screen, s[:HAPPY_BIRD], win)

    # initialise score
    screen_width = screen[0].length # length of any value in screen array
    score_x_pos = screen_width - s[:SCORE_MARGIN] - s[:PIPE_HEAD].length - 1
    score_y_pos = s[:SCREEN_HEIGHT] - s[:SCORE_MARGIN]
    draw_score(screen, score_y_pos, score_x_pos, score, win)

    # initialise screen
    draw_to_screen(screen, s[:BIRD_START_Y] + 2, s[:BIRD_START_X], "[SPACE] to jump", win)
    win.refresh

    # start on spacebar press
    input_wait(" ")
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

        draw_pipes(s, pipes, x_offset, screen, win)
        draw_score(screen, score_y_pos, score_x_pos, score, win)

        
        
        # check for off-screen or collision (when replaced range is not " ")
        if !read_from_screen(screen, bird.y_pos, range(bird.x_pos, s[:HAPPY_BIRD].length-1)).match(" ")

            # show user where they crashed
            game_running = false
            draw_bird(bird, screen, s[:SAD_BIRD], win, 4) # make bird red
            win.refresh
            sleep(s[:END_DELAY])

            # show final score
            render(end_screen(score), win)
            leaderboard.new_entry(:YOU, score)
            select_option(win, leaderboard, options)
            game_start(SETTINGS, win)

        else
            if bird.y_pos >=0
                draw_bird(bird, screen, s[:HAPPY_BIRD], win)
            end
            win.refresh
            sleep(s[:SCROLL_SPEED])
        end
    end
end

render(main_menu + game_options, win)

select_option(win, leaderboard, game_options)
