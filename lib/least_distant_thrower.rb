module JamesRoshambo
  class LeastDistantThrower
    def throw(my_throws, their_throws)
      mine = my_throws.reduce({:rock => 0, :scissors => 0, :paper => 0}) {|memo, t| memo[t] += 1; memo}
      theirs = their_throws.reduce({:rock => 0, :scissors => 0, :paper => 0}) {|memo, t| memo[t] += 1; memo}
      {
        :rock => (mine[:rock] - theirs[:rock]).abs, 
        :scissors => (mine[:scissors] - theirs[:scissors]).abs, 
        :paper => (mine[:paper] - theirs[:paper]).abs
      }.sort_by{|k,v| v}.first[0]
    end
  end
end