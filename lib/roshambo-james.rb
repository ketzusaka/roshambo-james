require "rock_thrower.rb"
require "paper_thrower.rb"
require "scissor_thrower.rb"
require "least_played_thrower.rb"
require "most_played_thrower.rb"
require "least_distant_thrower.rb"
require "most_distant_thrower.rb"
require "history.rb"

module JamesRoshambo
  class Player
    @@strategies = [LeastPlayedThrower, MostPlayedThrower, LeastDistantThrower, MostDistantThrower, RockThrower, PaperThrower, ScissorThrower]
    DESIRED_HIGH_WIN_PERCENT = 0.65
  
    def name
      "James"
    end
  
    def reset(seed)
      @my_throws = Array.new
      @opponent_throws = Array.new
      @history = {}
    
      prepare_initial_strategy(seed)
    end
  
    def throw
      @my_throws << @strategy.throw(@my_throws, @opponent_throws)
      @my_throws.last
    end
  
    def last_competitor_throw=(thrown)
      @opponent_throws << thrown
      process_last_winner
    end
  
    def process_last_winner
      won = did_i_win?(@my_throws.last, @opponent_throws.last)
      @history[current_history_key] ||= History.new 
      @history[current_history_key].add_throw_result(won) unless won.nil?
      pick_strategy
    end
  
    private
    def prepare_initial_strategy(seed)
      if seed < 0.33
        @strategy = RockThrower.new
      elsif seed < 0.66
        @strategy = PaperThrower.new
      else
        @strategy = ScissorThrower.new
      end
    end
  
    def did_i_win?(throw1, throw2)
      if (throw1 == :rock && throw2 == :scissors) || (throw1 == :scissors && throw2 == :paper) || (throw1 == :paper && throw2 == :rock)
        true
      elsif (throw1 == :scissors && throw2 == :rock) || (throw1 == :paper && throw2 == :scissors) || (throw1 == :rock && throw2 == :paper)
        false
      else
        nil
      end
    end
  
    def current_history_key
      @strategy.class
    end
  
    def pick_strategy
      return unless @history[current_history_key].count >= 2
      highest_winner = pick_high_winning_strategy
      @strategy = highest_winner.new and return unless highest_winner.nil?
    
      new_strategy = pick_unused_strategy
      @strategy = new_strategy.new and return unless new_strategy.nil?
      @strategy = pick_least_lame_strategy.new
    end
  
    def pick_high_winning_strategy
      @history.map {|c, history| [history.win_percent, c] }.
        sort{|a,b| a[0] <=> b[0]}.
        reduce([]) {|memo, obj| obj[0] >= DESIRED_HIGH_WIN_PERCENT ? memo.push(obj[1]) : memo}.last
    end
  
    def pick_unused_strategy
      (@@strategies - @history.map{|c, dont_care| c}).first
    end
  
    def pick_least_lame_strategy
      @history.map {|c, history| [history.win_percent, c] }.
        sort{|a,b| a[0] <=> b[0]}.last[1]
    end
  end
end

