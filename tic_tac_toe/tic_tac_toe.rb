class TicTacToe
    module Communications
	    def initial_greeting
	        puts "WELCOME TO TIC-TAC-TOE"
	    end
	    def prompt_move(side)
	        puts "Your move, #{side}. Pick a square (1-3,1-3):"
	    end
	    def invalid_selection
	        "Invaid selection. Pick Again (1-3, 1-3):"
	    end
	end
	
    include Communications
    
	attr_accessor :game, :stats
	def initialize
		@game = GameNavigator.new
		@stats = GameStats.new
	end

	class GameStats
	    @@games_played = 0
	    @@x_games_won = 0
	    @@o_games_won = 0
	    
	    def initialize
	        @@games_played += 1
	    end
	    
	    def show_games_played
	        puts @@games_played
	    end
	end
	
	class GameNavigator
	    attr_accessor :board, :moves
	    def initialize
	        @board = []
	        @move = []
	        @moves = 1
	        3.times{@board << [nil, nil, nil]}
	    end
	    
	    def display_board
    		@board.each{ |row|
    			row.each{ |square| print square ? "|#{square}" : "| " }
    			print "|\n"
    		}
	    end

	    def split_choice(choice)
	        @move = choice.scan(/\d/).map{|num| num.to_i}
	    end
	    
	    def invalid_move
	        invalid = false
	        @move.each{ |num| invalid = true if num < 1 || num > 3 }
	        invalid
	    end
	    
	    def determine_move
	        @moves.odd? ? "X" : "O"
	    end
	    
	    def mark_x(row, column)
		    @board[row - 1][column -1] = "x"
    	end

    	def mark_o(row, column)
    		@board[row - 1][column -1] = "o"
    	end
	end
	
end

# Create TicTacToe instance
current = TicTacToe.new


# Set loop control variable
continue = true

# Print initial greeting
current.initial_greeting

# Continue game loop until win or tie is reached
while continue
    current.prompt_move(current.game.determine_move)
    begin
        current.game.split_choice(gets.chomp)
        raise current.invalid_selection if current.game.invalid_move
    rescue => e
        puts e
        retry
    end
    continue = false
end
