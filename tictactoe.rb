class TicTacToeGame
  attr_accessor :grid, :winner, :activeplayer
  def initialize
  @grid = {
  "a1"=>" ","a2"=>" ","a3"=>" ",
  "b1"=>" ","b2"=>" ","b3"=>" ",
  "c1"=>" ","c2"=>" ","c3"=>" "
  }
  @winner = [
    ["a1", "a2", "a3"],
    ["b1", "b2", "b3"],
    ["c1", "c2", "c3"],
    ["a1", "b1", "c1"],
    ["a2", "b2", "c2"],
    ["a3", "b3", "c3"],
    ["a1", "b2", "c3"],
    ["c1", "b2", "a3"]
  ]
  @activeplayer = "X"
end

  def gamegrid
    puts " a   b   c"
    puts "1  |#{@grid[a1]}|#{@grid[a2]}|#{@grid[a3]}|"
    puts " -------------"
    puts "2  |#{@grid[b1]}|#{@grid[b2]}|#{@grid[b3]}|"
    puts " -------------"
    puts "3  |#{@grid[c1]}|#{@grid[c2]}|#{@grid[c3]}|"
  end
  
  def player_turn
    puts "Player #{@activeplayer}, which location do you choose?"
    input = gets.downcase.squeeze
    if input.lenth == 2
      checkinput(input)
    else
      badinput
    end
  end
  
  def checkinput(input)
    x = input.split("")
    if (["a", "b", "c"].include?(x[0]) && ["1", "2", "3"].include?(x[1]) && @grid[input] == " ")
       @grid[input] = @activeplayer
      if @activeplayer == "O"
         @activeplayer = "X"
      else @activeplayer = "O"
    end
      checkgame
    else
      badinput
    end
  end
  
  def badinput
    puts "You must choose a valid and empty slot"
    gamegrid
    player_turn
  end
  
  def winnercheck(cell, player)
    n = 0
    cell.each do |i|
      n += 1 if @grid[i] == player
    end
    n
  end
  
  def checkgame
    @winner.each do |cell|
      if winnercheck(cell, "X") == 3
        puts "Player X wins!"
      elsif winnercheck(cell, "O") == 3
        puts "Player O wins!"
      else
        gamegrid
        puts "------------------------------"
        player_turn
      end
    end
  end
end