module JamesRoshambo
  class LeastPlayedThrower
    def throw(dontcare, their_throws)
      their_throws.reduce({:rock => 0, :scissors => 0, :paper => 0}){|memo, thrown| memo[thrown] += 1; memo}.sort_by{|k,v| v}.first[0]
    end
  end
end