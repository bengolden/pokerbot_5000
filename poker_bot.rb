class PokerHand
	def initialize(hand)
		@hand = hand
	end

	def straight?
		return false if invalid_hand?
		@hand.sort_by!{|card|card.num}
		(1..4).all? do |index|
			@hand[0].num == @hand[index].num - index
		end
	end

	def flush?
		return false if invalid_hand?
		@hand.all? do |card|
			@hand[0].suit == card.suit
		end
	end

	def straight_flush?
		straight? && flush?
	end

	def invalid_hand?
		@hand.length != 5
	end

end

class Card
	attr_reader :num, :suit
	def initialize(num,suit)
		@num = num
		@suit = suit
	end
end
