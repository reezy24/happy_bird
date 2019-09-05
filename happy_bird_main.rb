require_relative "happy_bird_pipes"
require_relative "bird"
require_relative "settings"
require_relative "main_menu"
require_relative "end_screen"
require_relative "leaderboard"
require "tty-reader"
require "curses"

include Curses

# curses
init_screen # prevent flicker
start_color
init_pair(1, COLOR_GREEN, COLOR_BLACK)
attrset(color_pair(1) | A_NORMAL)
win = Window.new(SETTINGS[:SCREEN_HEIGHT], 100, 0, 0)
win.nodelay = true # set listening for user input to nonblocking

leaderboard = Leaderboard.new

def range(lower, upper)
    return lower..lower + upper
end

def draw_to_screen(screen, y, x, str)
    screen[y] = "" if !screen[y] # create row
    screen[y][range(x, str.length-1)] = str
end

def read_from_screen(screen, y, x_range)
    return screen[y][x_range]
end

def draw_pipes(settings, pipes, pipe_offset, screen)
    s = settings
    viewport = range(pipe_offset, s[:DIST_BETWEEN_PIPES_X] * (pipes.length - 1))
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
        draw_to_screen(screen, i, 0, this_row[viewport]+"\n")
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
        #window.attrset(color_pair(1) | A_NORMAL)
        window.addstr(row)
    end
    window.refresh
end

def select_option(win, leaderboard)
    reader = TTY::Reader.new
    case reader.read_char
    when " "
        game_start(SETTINGS, win, leaderboard)
    when "l"
        render(leaderboard.to_screen, win)
        select_option(win, leaderboard)
    when "q"
        exit
    else
        select_option(win, leaderboard)
    end
end

def input_wait(input)
    reader = TTY::Reader.new
    input_wait(input) unless reader.read_char == input
end

def game_start(settings, win, leaderboard)

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
    draw_pipes(s, pipes, x_offset, screen)

    # initialise bird
    bird = Bird.new(s[:BIRD_START_X], s[:BIRD_START_Y], 0, s[:BIRD_JUMP_POW])
    draw_bird(bird, screen, s[:HAPPY_BIRD])

    # initialise score
    screen_width = screen[0].length # length of any value in screen array
    score_x_pos = screen_width - s[:SCORE_MARGIN] - s[:PIPE_HEAD].length - 1
    score_y_pos = s[:SCREEN_HEIGHT] - s[:SCORE_MARGIN]
    draw_score(screen, score_y_pos, score_x_pos, score)

    # initialise screen
    draw_to_screen(screen, s[:BIRD_START_Y] + 2, s[:BIRD_START_X], "[SPACE] to jump")
    render(screen, win)

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

        draw_pipes(s, pipes, x_offset, screen)
        draw_score(screen, score_y_pos, score_x_pos, score)

        
        
        # check for off-screen or collision (when replaced range is not " ")
        if (bird.y_pos > s[:SCREEN_HEIGHT]) || !read_from_screen(screen, bird.y_pos, range(bird.x_pos, s[:HAPPY_BIRD].length-1)).match(" ")

            # show user where they crashed
            game_running = false
            draw_bird(bird, screen, s[:SAD_BIRD])
            # make bird red
            render(screen, win)
            sleep(s[:END_DELAY])

            # show final score
            render(end_screen(score), win)
            #leaderboard.new_entry(gets.chomp.to_sym, score)
            select_option(win, leaderboard)
            game_start(SETTINGS, win)

        else
            draw_bird(bird, screen, s[:HAPPY_BIRD])
            render(screen, win)
            sleep(s[:SCROLL_SPEED])
        end
    end
end

render(main_menu, win)

select_option(win, leaderboard)
