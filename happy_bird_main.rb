require_relative "happy_bird_pipes"
require_relative "bird"
require_relative "settings"
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

def render(screen, window)
    window.clear
    screen.each do |row|
        window.addstr(row)
    end
    window.refresh
end

def game_start(settings)

    s = settings

    # curses stuff
    init_screen # prevent flicker
    noecho # hide user input

    # game state vars
    game_running = false
    x_offset = 0
    reader = TTY::Reader.new
    screen = []

    # initialise pipes
    starter_pipe = Pipe.new(s[:STARTER_PIPE_HEIGHT], s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y])
    random_pipe = RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])
    pipes = [nil, starter_pipe, starter_pipe, random_pipe]

    # initialise bird
    bird = Bird.new(1, 5, 0, s[:BIRD_JUMP_POW])
    #bird = Bird.new(s[:BIRD_START_X], s[:BIRD_START_Y], 0, s[:BIRD_JUMP_POW])

    # initialise screen
    draw_pipes(s, pipes, x_offset, screen)
    screen_width = screen[0].length # length of any value in screen
    win = Window.new(s[:SCREEN_HEIGHT], screen_width, 0, 0)
    win.nodelay = true # set listening for user input to nonblocking
    render(screen, win)

    # start on spacebar press
    until reader.read_char == " "
      game_running = false
    end
    game_running = true

    # render every frame until end
    while game_running

        screen = []

        # bird testing
        if win.getch == " "
            bird.jump #if bird.y_pos >= 10
        end
        bird.move(50, 0.05)
        
        # adjust x_offset
        if x_offset == s[:DIST_BETWEEN_PIPES_X]
            x_offset = 0
            pipes.push(RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])).shift
        else
            x_offset += 1
        end

        # draw and render
        draw_pipes(s, pipes, x_offset, screen)
        if !read_from_screen(screen, bird.y_pos, bird.x_pos..":)".length-1).match(" ")
            game_running = false
            # make bird red and sad
        else
            draw_bird(bird, screen, ":)")
        end

        render(screen, win)

        sleep(0.05)

    end
end

game_start(SETTINGS)