class MasterMind
    
    attr_reader :guessgrid, :exactgrid, :colorgrid, :counter, :code, :gametype, :game

    @@guessestosolve = []
    @@gameswon = 0


    # This module contains functions to facilitate the execution of the MasterMind game
    module GameHelper
        # Creates a randomly generated code of four numbers, 1-4
        def generate_code
            code = []
            4.times{ code << rand(1..4) }
            code
        end
        
        # Translates the number code to corresponding colors
        def translate_num_to_color(num)
            case num
                when 1
                    "black"
                when 2
                    "white"
                when 3
                    "red"
                when 4
                    "green"
            end
        end
        
        # Translates colors to the corresponding number codes 1-4
        def translate_color_to_num(color)
            case color
                when "b"
                    1
                when "w"
                    2
                when "r"
                    3
                when "g"
                    4
            end
        end
        
        def invalid_selection
            "invalid selection. Try again:"
        end

        def prompt_game_type
            puts "Human, enter 1 to be the code master, or 2 to be the code breaker"
        end
    end
    
   # This class contains the attributes and functions for the game
    class Game
        attr_accessor :code, :word_code, :guess, :num_guess, :remaining_guesses
        
        include GameHelper
        
        # creates a new code to solve and converts the code to colors, stored in a different attribute
        def initialize
            @code = generate_code
            @word_code = convert_code
            @guess = []
            @num_guess = []
            @remaining_guesses = 12
        end
        
        # calls on translate_num_to_color to convert numbers to colors
        def convert_code
            @code.map{ |num| translate_num_to_color(num) }
        end
        
        # takes user input and breaks it into a code guess array
        def capture_guess(user_input)
            @guess = user_input.scan(/./)
        end

        def verify_guess
            verify_letters && verify_size
        end

        def verify_letters
            @guess.all?{ |letter| letter =~ /[bwrg]/ }
        end

        def verify_size
            @guess.size == 4
        end

        def decrement_guesses
            @remaining_guesses -= 1
        end
        
        def convert_guess
            @num_guess = @guess.map{ |letter| translate_color_to_num(letter) }
        end
        
        # returns true if the code is guessed correctly
        def code_cracked?
            @num_guess == @code
        end
        
        # print the player's turn result
        def turn_result
            puts "matches: #{exact_matches}"
            puts "color matches: #{color_matches(get_code_remainder, get_guess_remainder)}"
        end
        
        # returns number of color matches for the guess. Takes unmatched code & guess arrays as inputs.
        def color_matches(code, guess)
            colormatches = 0
            guess.each{ |num| colormatches += 1 if code.any?{|x| x == num} }
            colormatches
        end
        
        # makes an array of code elements not matched by the guess
        def get_code_remainder
            code_remainder = []
            4.times{ |x| code_remainder << @code[x] if @num_guess[x] != @code[x] }
            code_remainder
        end
        
        # makes an array of guess elements not matching the code
        def get_guess_remainder
            guess_remainder = []
            4.times{ |x| guess_remainder << @num_guess[x] if @num_guess[x] != @code[x] }
            guess_remainder
        end
        
        # returns the number of exact matches in the guess
        def exact_matches
            matches = 0
            4.times{ |x| matches += 1 if @num_guess[x] == @code[x] }
            matches
        end
    end

    include GameHelper

    def initialize
        @code = generate_code
        @guessgrid = [[0,0,0,0]]
        @exactgrid = [0]
        @colorgrid = [0]
        @counter = 0
        @bestguess = 1
        @bestcombined = 0
        @game = Game.new

    end


    def self.increment_guessestosolve(trys)
        @@guessestosolve << trys
    end
    
    def self.avg_to_solve
        @@guessestosolve.inject{ |sum, n| sum += n }.to_f / @@guessestosolve.size
    end
    
    def self.games_won_percentage
        "#{(@@gameswon / @@guessestosolve.size.to_f) * 100}%"
    end
    
    def self.increment_games_won
        @@gameswon += 1 if @@guessestosolve.last < 13
    end
    
    def self.games_won
        @@gameswon
    end
    
    def increment_counter
        @counter += 1
    end

    def set_game_type(selection)
        if selection == 1
            @gametype = :master
        elsif selection == 2
            @gametype = :breaker
        else
            false
        end               
    end
    
    def set_best_combined
        temp = []
        @exactgrid.size.times{ |x| temp << @exactgrid[x] + @colorgrid[x] }
        @bestcombined = temp.find_index(temp.max)
        @bestcombined > 0 ? @bestcombined : @bestcombined = 1
    end
    
    def best_combined
        @exactgrid[set_best_combined]
    end
    
    def set_best_exact
        @bestguess = @exactgrid.find_index(@exactgrid.max)
        @bestguess > 0 ? @bestguess : @bestguess = 1
    end
    
    
    def random_code
        temp = []
        4.times{ temp << rand(1..4) }
        temp
    end
    
    def best_exact
        @exactgrid[@bestguess]
    end
    
    def random_guess
        temp = []
        4.times{ temp << rand(1..4) }
        @guessgrid << temp
        
        increment_counter
        
        @exactgrid << exact_matches
        @colorgrid << color_matches
        set_best_exact
    end
    
    def random_number
        rand(1..4)
    end
    
    def random_index
        rand(0..3)
    end
    
    def unique_guess?(newguess)
        !@guessgrid.include?(newguess)
    end
    
    def build_guess(loc=@counter)
        indexes = []
        remaining = [0,1,2,3]
        randguess = []
        num = 0

        unique = false
        
        until unique
            temp = [0,0,0,0]
            tempcolor = []
            indexes.clear
            choice = []
            deposit = nil
            
            # populate indexes array with random index locations, equal in number to exact matches of last guess
            exact_matches(loc).times{ indexes << random_index }

            
            # store a number of elements, equal to the size of indexes array, from the last guess in the temp array
            indexes.size.times{ |x| temp[indexes[x]] = @guessgrid[loc][indexes[x]] }
            
            
            # Incorporate color matches here
            counter = 0
            if color_matches(loc) > 0
                # while counter < color_matches(loc) || temp.none?{ |x| x == 0 }
                until remaining.empty? || temp.none?{ |x| x == 0 }
                    remaining = remaining - indexes - choice
                    choice.clear
                    choice << remaining.sample
                    temp.size.times{ |x| tempcolor << x if temp[x] == 0 }
                    deposit = tempcolor.sample
                    temp[deposit] = @guessgrid[loc][choice.first] if !remaining.empty?
                    tempcolor.clear
                    counter += 1
                end
            end
            
            # fill in the remaining elements of the temp array with random numbers
            temp.map!{ |num| num == 0 ? num = random_number : num }
            unique = true if unique_guess?(temp)
        end
        
        increment_counter
        
        # push the new guess to the guessgrid
        @guessgrid << temp
        @exactgrid << exact_matches
        @colorgrid << color_matches
        
        set_best_exact
    end
    
    def next_guess
        if exact_matches == 0
            random_guess
        elsif exact_matches > best_exact
            build_guess
        else
            build_guess(set_best_exact)
        end
    end
    
    # returns number of color matches for the guess. This needs to be simplified!
    def color_matches(loc=@counter)
        code = get_code_remainder(loc)
        guess = get_guess_remainder(loc)
        x = 0
        y = 0
        index = 0
        totalmatches = 0
        matches = 0
        guess.each{|g|
            code.each{ |c| 
                if c == g && matches == 0
                    matches += 1
                    guess[x] = 0
                    code[y] = 5
                end
                y += 1
            }
            y = 0
            totalmatches += 1 if matches > 0
            matches = 0
            x += 1
        }
        totalmatches
    end
    
    # makes an array of code elements not matched by the guess
    def get_code_remainder(loc=@counter)
        code_remainder = []
        4.times{ |x| code_remainder << @code[x] if @guessgrid[loc][x] != @code[x] }
        code_remainder
    end
    
    # makes an array of guess elements not matching the code
    def get_guess_remainder(loc=@counter)
        guess_remainder = []
        4.times{ |x| guess_remainder << @guessgrid[loc][x] if @guessgrid[loc][x] != @code[x] }
        guess_remainder
    end
    
    # returns the number of exact matches in the guess
    def exact_matches(loc=@counter)
        matches = 0
        4.times{ |x| matches += 1 if @guessgrid[loc][x] == @code[x] }
        matches
    end
    
    def code_cracked?
        # exact_matches == 4
        @guessgrid.last == @code
    end


end

# ****************************************************************
# ****************************************************************
# ****************************************************************

current = MasterMind.new

current.prompt_game_type

# Loop until valid game type selection is made
begin        
    # raise exception if invalid user entry
    raise current.invalid_selection unless current.set_game_type(gets.chomp.to_i)
rescue => e
    puts e
    retry
end


if current.gametype == :breaker
	# Run game as code breaker
	# loop until code is guessed or remaining guesses run out
	until current.game.code_cracked? || current.game.remaining_guesses == 0

	    puts "The code is: #{current.game.code}"
	    puts "Enter your code guess:"

	    # Loop until valid user entry is captured
	    begin

	        # capture user code guess
	        current.game.capture_guess(gets.chomp.downcase)
	        
	        # raise exception if invalid user entry
	        raise current.game.invalid_selection unless current.game.verify_guess
	        
	    rescue => e
	        puts e
	        retry
	    end
	    
	    # convert user guess to numerical
	    current.game.convert_guess
	    
	    # decrement remaining guesses
	    current.game.decrement_guesses


	    if current.game.code_cracked?
	        puts "You cracked the code, MasterMind!"
	    else
	        puts "Incorrect guess.  Your result:"
	        puts "#{current.game.turn_result}"
	    end
	end

else
	# Run game as code master
	10.times{
	    current = MasterMind.new

	    current.random_guess
	    
	    until current.code_cracked?
	        current.next_guess
	    end
	    if current.code_cracked? 
	            # puts "MasterMind!, in #{current.counter} guesses."
	            MasterMind.increment_guessestosolve(current.counter)
	            MasterMind.increment_games_won
	    else
	            puts "Code not cracked: #{current.code_cracked?}"
	    end
	}
	puts "average guesses to break code: #{MasterMind.avg_to_solve}"
	puts "games won: #{MasterMind.games_won}"
	puts "winning percentage: #{MasterMind.games_won_percentage}"
end



# 10.times{
#     current = MasterMind.new

#     current.random_guess
    
#     until current.code_cracked?
#         current.next_guess
#     end
#     if current.code_cracked? 
#             # puts "MasterMind!, in #{current.counter} guesses."
#             MasterMind.increment_guessestosolve(current.counter)
#             MasterMind.increment_games_won
#     else
#             puts "Code not cracked: #{current.code_cracked?}"
#     end
# }
# puts "average guesses to break code: #{MasterMind.avg_to_solve}"
# puts "games won: #{MasterMind.games_won}"
# puts "winning percentage: #{MasterMind.games_won_percentage}"
