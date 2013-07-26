module JamesRoshambo
  class History
    def initialize
      @wins = 0
      @loses = 0
      @ties = 0
    end
  
    def win_percent
      @wins.to_f / (@wins+@loses).to_f
    end
  
    def add_throw_result(won)
      @ties += 1 and return if won.nil?
      won ? @wins += 1 : @loses += 1
    end
  
    def count
      @wins + @loses + @ties
    end
  end
end