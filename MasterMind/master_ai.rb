class MasterMind
    attr_reader :guessgrid, :exactgrid, :colorgrid, :counter, :code
    @@guessestosolve = []
    @@gameswon = 0
    
    def initialize
        @code = [1,3,2,2]
        @guessgrid = [[0,0,0,0]]
        @exactgrid = [0]
        @colorgrid = [0]
        @counter = 0
        @bestguess = 1
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
    
    def set_best_guess
        @bestguess = @exactgrid.find_index(@exactgrid.max)
        @bestguess > 0 ? @bestguess : @bestguess = 1
    end
    
    def best_guess
        @exactgrid[@bestguess]
    end
    
    def random_guess
        temp = []
        4.times{ temp << rand(1..4) }
        @guessgrid << temp
        
        increment_counter
        
        @exactgrid << exact_matches
        @colorgrid << color_matches
        set_best_guess
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
        unique = false
        
        until unique
            temp = [0,0,0,0]
            indexes.clear
            
            # populate indexes array with random index locations, equal in number to exact matches of last guess
            exact_matches(loc).times{ indexes << random_index }
            
            # store a number of elements, equal to the size of indexes array, from the last guess in the temp array
            indexes.size.times{ |x| temp[indexes[x]] = @guessgrid[loc][indexes[x]] }
            
            # fill in the remaining elements of the temp array with random numbers
            temp.map!{ |num| num == 0 ? num = random_number : num }
            
            unique = true if unique_guess?(temp)
        end
        
        increment_counter
        
        # push the new guess to the guessgrid
        @guessgrid << temp
        @exactgrid << exact_matches
        @colorgrid << color_matches
        set_best_guess
    end
    
    def next_guess
        if exact_matches == 0
            random_guess
        elsif exact_matches > best_guess
            build_guess
        else
            build_guess(set_best_guess)
        end
    end
    
    # returns number of color matches for the guess. This needs to be simplified!
    def color_matches
        code = get_code_remainder
        guess = get_guess_remainder
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
        exact_matches == 4
    end
end

10000.times{
    current = MasterMind.new
    # puts "Code: #{current.code.inspect}"
    current.random_guess
    # puts "guess: #{current.guessgrid[current.counter].inspect}"
    # puts "exactgrid: #{current.exactgrid[current.counter].inspect}"
    # puts "colorgrid: #{current.colorgrid[current.counter].inspect}"
    # current.update_best
    
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
