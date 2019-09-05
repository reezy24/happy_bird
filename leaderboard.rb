leaderboard = {
    John: 1,
    Zach: 2, 
    Mary: 3
}

def add_leaderboard_entry(leaderboard, name, score)
    leaderboard[:name] = score
end

def leaderboard_screen
    p "This is the leaderboard"
    p "[SPACE] to play"
end

