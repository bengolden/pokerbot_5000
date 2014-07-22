class PokerHand
	def initialize(hand)
		@hand = hand.sort_by{|card|card.num}
	end

	def straight?
		return false if values_present.length < 5
		values_present.each_cons(5).any? do |five_card_hand|
			(1..4).all? do |index|
				five_card_hand[index] - five_card_hand[0] == index
			end
		end
	end

	def flush?
		suit_counts[0] >= 5
	end

	def straight_flush?
		straight? && flush?
	end

	def full_house?
		value_counts[0] == 3 && value_counts[1] == 2
	end

	def two_pair?
		value_counts[0] == 2 && value_counts[1] == 2
	end

	def quads?
		value_counts[0] == 4
	end

	def trips?
		value_counts[0] == 3
	end

	def pair?
		value_counts[0] == 2
	end

	def value_counts
		@hand.group_by{|card| card.num}.values.map{|cards|cards.count}.sort.reverse
	end

	def values_present
		output = @hand.map{|card|card.num}.uniq
		output = [1] + output if output.last == 14
		output
	end

	def suit_counts
		@hand.group_by{|card| card.suit}.values.map{|cards|cards.count}.sort.reverse
	end

end

class Card
	attr_reader :num, :suit
	def initialize(num,suit)
		@num = num
		@suit = suit
	end
end