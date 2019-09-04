require_relative "happy_bird_pipes"
require "tty-reader"
# read a character without pressing enter and without printing to the screen
# def read_char
#     begin
#       # save previous state of stty
#       old_state = `stty -g`
#       # disable echoing and enable raw (not having to press enter)
#       system "stty raw -echo"
#       c = STDIN.getc.chr
#       # gather next two characters of special keys
#       if(c=="\e")
#         extra_thread = Thread.new{
#           c = c + STDIN.getc.chr
#           c = c + STDIN.getc.chr
#         }
#         # wait just long enough for special keys to get swallowed
#         extra_thread.join(0.00001)
#         # kill thread so not-so-long special keys don't wait on getc
#         extra_thread.kill
#       end
#     rescue => ex
#       puts "#{ex.class}: #{ex.message}"
#       puts ex.backtrace
#     ensure
#       # restore previous state of stty
#       system "stty #{old_state}"
#     end
#     return c
#   end

SETTINGS = {
    
    #config
    SCREEN_HEIGHT: 20,
    DIST_BETWEEN_PIPES_X: 25,
    DIST_BETWEEN_PIPES_Y: 6,
    MIN_PIPE_HEIGHT: 2,
    SCROLL_SPEED: 0.5, # 1/SCROLL_SPEED = how many times the screen moves a second
    STARTER_PIPE_HEIGHT: 5,

    #graphics
    PIPE_HEAD: "[|||||]",
    PIPE_BODY: " ||||| ",
    PIPE_GAP:  "       ",
    HAPPY_BIRD: ":)",
    SAD_BIRD: ":(",

}

def update(settings, pipes, pipe_offset)
    s = settings
    # draw the screen
    system("clear")
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
        p this_row[range]
    end
end

def game_start(settings)

    # game state vars
    s = settings
    game_running = false
    x_offset = 1
    reader = TTY::Reader.new

    # start with empty, start pipe, start pipe, start pipe
    starter_pipe = Pipe.new(s[:STARTER_PIPE_HEIGHT], s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y])
    random_pipe = RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])
    pipes = [nil, starter_pipe, starter_pipe, random_pipe]

    # draw screen but don't start moving yet
    update(s, pipes, 0)
    until reader.read_char == " "
      game_running = false
    end
    game_running = true

    while game_running
        update(s, pipes, x_offset)
        # delay loop by game_speed
        sleep(0.05)
        if x_offset == s[:DIST_BETWEEN_PIPES_X]
            x_offset = 0
            pipes.push(RandomPipe.new(s[:SCREEN_HEIGHT], s[:DIST_BETWEEN_PIPES_Y], s[:MIN_PIPE_HEIGHT])).shift
        else
            x_offset += 1
        end
        reader.read_char
    end
end

game_start(SETTINGS)