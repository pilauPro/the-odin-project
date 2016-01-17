class TicTacToe
    module GameHelper
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
	
    include GameHelper
    
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

	    def square_occupied?
	    	@board[@move[0] - 1][@move[1] - 1] != nil
	    end
	    
	    def determine_move
	        @moves.odd? ? "X" : "O"
	    end
	    
	    def mark_move(mark)
		    @board[@move[0] - 1][@move[1] - 1] = mark
    	end

    	def increment_moves
    		@moves += 1
    	end

    	def game_over?
    		full_board? || row_winner? || column_winner? || diagonal_winner?
    	end

    	def row_winner?
    		@board.find_index{ |row| row == ["X", "X", "X"] || row == ["O", "O", "O"]}
    	end

    	def column_winner?
    		make_vert_array.find_index{ |row| row == ["X", "X", "X"] || row == ["O", "O", "O"]}
    	end

    	def diagonal_winner?
			true if [@board[0][0], @board[1][1], @board[2][2]] == ["X", "X", "X"] || [@board[0][0], @board[1][1], @board[2][2]] == ["O", "O", "O"]
			true if [@board[0][2], @board[1][1], @board[2][0]] == ["X", "X", "X"] || [@board[0][2], @board[1][1], @board[2][0]] == ["O", "O", "O"]
    	end

    	def full_board?
    		@board.all?{|row|
			    row.all?{|space| space}
			}	
    	end

    	def make_vert_array
    		i = 0
    		vert_ar = []
    		3.times{ 
			    vert_ar << [@board[0][i], @board[1][i], @board[2][i]]
			    i += 1
			}
			vert_ar
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
        raise current.invalid_selection if current.game.invalid_move || current.game.square_occupied?
    rescue => e
        puts e
        retry
    end

    current.game.mark_move(current.game.determine_move)
    current.game.display_board
    current.game.increment_moves
    
    continue = false if current.game.game_over?
end
