require 'fileutils'
require 'csv'

data_file = ARGV[0]
@state_count = Hash.new
@states = Hash.new
@cities = Hash.new
@results = Hash.new

# Read in states, abbreviations, population
File.open("states.txt") do |fp|
    fp.each do |line|
        line = line.chomp.split(",")
        
        state = line[0]
        
        stateHash = Hash.new
        stateHash["abbreviation"] = line[1]
        stateHash["population"] = line[2]
        @states[state] = stateHash
    end
end

# Read in cities
File.open("cities.txt") do |fp|
    fp.each do |line|
        line = line.chomp.split(",")
        @cities[line[0]] = line[1]
    end
end

def checkCity(location)
    
     @cities.each do |key, value|
        city = key
        state = value
        
        if location.include?(city)
            return state
        end
     end
     
    return "NONE"
end

# Read in each tweet.  Check to see if location has state/city
# Check LOC2 for state match OR LOC1 state match OR LOC1 abbreviation (WC)
# If no match, check LOC1 for city match
File.open(data_file) do |fp|
    fp.each do |line|
        line = line.chomp.split("\t")
        state_found = false
        #puts line
        loc1 = line[1].downcase
        loc2 = line[2].downcase
        
        @states.each do |key, value|
            state = key
            stateHash = value
            abv_state = stateHash["abbreviation"]
            abv_state1 = ",#{abv_state}\""
            abv_state2 = ", #{abv_state}\""
            
            if loc2.include?(state) || loc1.include?(state) || loc1.match(/#{abv_state1}/) || loc1.match(/#{abv_state2}/)
                #puts "#{state}: #{loc1}  OR #{loc2}"
                current = @state_count[state]
                new_count = current.to_i + 1
                @state_count[state] = new_count
                state_found = true
                break
            end
        end
        
        if !state_found
            city_state = checkCity(loc1)
            if city_state != "NONE"
                #puts "#{city_state}: #{loc1}  [CITY]"
                current = @state_count[city_state]
                new_count = current.to_i + 1
                @state_count[city_state] = new_count
            end
         end  
    end
end

# Get population and compute ratio
# count / population (rounded by 2 decimals)
@state_count.each do |key, value|
    state = key
    population = @states[state]["population"].to_f
    count = value.to_f
    ratio = (count/population)*100000
    ratio = format("%0.2f", ratio)
    
    puts "#{state},#{count.to_i},#{population.to_i},#{ratio}"
end

