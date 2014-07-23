class PokerHand
	def initialize(hand)
		@hand = hand.sort_by{|card|card.num}
		@straight_top
	end

	def evaluate
		if straight_flush?
			[8, @straight_top]
		elsif straight?
			[4, @straight_top]
		elsif quads?
			[7] + quads_kickers
		elsif full_house?
			[6] + house_kickers
		elsif flush?
			[5] + natural_kickers
		elsif trips?
			[3] + trips_kickers
		elsif two_pair?
			[2] + two_pair_kickers
		elsif pair?
			[1] + pair_kickers
		else
			[0] + natural_kickers
		end
	end

	def straight?
		return false if values_present(@hand).length < 5
		values_present(@hand).each_cons(5).any? do |five_card_hand|
			if 
				(1..4).all? do |index|
					five_card_hand[index] - five_card_hand[0] == index
				end
				@straight_top = five_card_hand[4]
				return true
			else
				false
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
		value_counts_and_values.values.map{|cards|cards.count}.sort.reverse
	end

	def value_counts_and_values
		@hand.group_by{|card| card.num}
	end

	def repeated_values(times)
		value_counts_and_values.select{|k,v| v.length == times}
	end

	def values_present(hand)
		output = hand.map{|card|card.num}.uniq
		output = [1] + output if output.last == 14
		output
	end

	def suit_counts
		@hand.group_by{|card| card.suit}.values.map{|cards|cards.count}.sort.reverse
	end

	def kickers
		values_present(@hand).sort.reverse[0..4]
	end

	def natural_kickers
		kickers
	end

	def repeat_kickers(repetition,length)
		repetition = repeated_values(repetition).keys.sort.reverse
		(repetition + (kickers - repetition))[0..length-1]
	end

	def pair_kickers
		repeat_kickers(2,4)
	end

	def two_pair_kickers
		repeat_kickers(2,3)
	end

	def trips_kickers
		repeat_kickers(3,3)
	end

	def quads_kickers
		repeat_kickers(4,2)
	end

	def house_kickers
		triple = repeated_values(3).keys
		pair = repeated_values(2).keys
		triple + pair
	end

end

class Card
	attr_reader :num, :suit
	def initialize(num,suit)
		@num = num
		@suit = suit
	end
end