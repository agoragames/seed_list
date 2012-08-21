# Strategy classes are responsible for matching up players against each other
# in the first round of a bracket. A strategy is chosen for each tournament by the host.
#
# Player objects have a numeric property #seed, which is set at creation
# and may be reordered by the host. These positions are ranked by skill from 
# best (1) to worst (max).
#
# When the Bracket is generated, the players are sorted in accordance with the
# chosen strategy logic.
module SeedList
  module Strategy
    class Base
      attr_accessor :players
      def initialize(players); @players = players; end
      def seed; raise 'Abstract method called'; end
    end

    # Players matched against each other at random. A player's seed position is
    # completely irrelevant.
    class Knockout < Base
      def seed
        @players.shuffle
      end
    end

    # Best matched against worst, second best against second worst, and so on.
    # Optimized for serious players and viewer entertainment.
    class Playoff < Base
      def seed
        input, output = @players.clone, []
        input.size.times { |i| output << (i.even? ? input.shift : input.pop) }
        output
      end
    end

    # TODO This strategy is implemented incorrectly, with an associated pending test.
    # Best matched against worst, second best against second worst, and so on.
    # Ensures that if the higher seed wins, he will always face someone from the 
    # lower half in the next round.
    class MLGPlayoff < Base
      def seed
        input, sequence, pairs, output = @players.clone, [], [], []
        input.size.times { |i| sequence << (i.even? ? input.shift : input.pop) }
        loop { pairs << sequence.shift(2); break if sequence.empty? }
        pairs.size.times { |i| output << (i.even? ? pairs.shift : pairs.pop) }
        output.flatten
      end
    end

    # Matched by similar skill straight through; best on the top, worst on the bottom.
    # Optimized for friendly tournaments with diversely skilled players (to prevent casual
    # players from being knocked out right away).
    class Amateur < Base
      def seed
        @players.sort { |a,b| a.seed <=> b.seed }
      end
    end
  end
end
