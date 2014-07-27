class PokerHand
	attr_accessor :hand
	attr_reader :straight_top
	def initialize(hand)
		@hand = hand
		@straight_top
	end

	def add_cards(cards)
		@hand = @hand + cards
	end

	def remove_cards(cards)
		@hand = @hand + cards
	end

	def card_count
		hand.length
	end

	def evaluate
		if straight_flush?
			[8, straight_top]
		elsif quads?
			[7] + quads_kickers
		elsif full_house?
			[6] + house_kickers
		elsif flush?
			[5] + flush_kickers
		elsif straight?
			[4, straight_top]
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

	def compare(other_hand)
		hand_strength = evaluate
		other_hand_strength = other_hand.evaluate
		hand_strength.length.times do |index|
			return 1 if hand_strength[index] > other_hand_strength[index]
			return -1 if hand_strength[index] < other_hand_strength[index]
		end
		0
	end

	def compare_to_range(board)
		dead_cards = @hand + board
		available_cards = PokerDeck.deal.select{|card| dead_cards.all?{|dead_card| card.num != dead_card.num || card.suit != dead_card.suit}}
		range = available_cards.combination(2).map{|cards| PokerHand.new(cards)}
		wins = 0
		losses = 0
		ties = 0
		hand_copy = self.dup
		hand_copy.add_cards(board)
		range.each do |other_hand|
			other_hand.add_cards(board)
			if hand_copy.compare(other_hand) == 1
				wins += 1
			elsif hand_copy.compare(other_hand) == -1
				losses += 1
			else
				ties += 1
			end
		end

	 	{wins: wins, losses: losses, ties: ties}
	end

	def straight?
		return false if values_present(hand).length < 5
		hand.sort_by!{|card|card.num}
		values_present(hand).each_cons(5).any? do |five_card_hand|
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
		if flush?
			flush_cards_only = self.dup
			this_hand = flush_cards_only.hand.dup
			this_hand.select! {|card| card.suit == flush_suit}
			flush_cards_only.hand = this_hand
			output = flush_cards_only.straight?
			@straight_top = flush_cards_only.straight_top
			return output
		end
		false
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
		hand.group_by{|card| card.num}
	end

	def repeated_values(times)
		value_counts_and_values.select{|k,v| v.length == times}
	end

	def values_present(hand)
		output = hand.map{|card|card.num}.uniq
		output = [1] + output if output.include?(14)
		output
	end

	def suit_counts
		hand.group_by{|card| card.suit}.values.map{|cards|cards.count}.sort.reverse
	end

	def flush_suit
		hand.group_by{|card| card.suit}.keys.sort.reverse[0]
	end

	def kickers
		values_present(hand).sort.reverse[0..4]
	end

	def natural_kickers
		kickers
	end

	def flush_kickers
		cards_of_flush_suit = hand.select{|card| card.suit == flush_suit}
		values_present(cards_of_flush_suit).sort.reverse[0..4]
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

SUITS = ['s','h','d','c']
VALUES = [2,3,4,5,6,7,8,9,10,11,12,13,14]

class PokerDeck
	def self.deal
		SUITS.each_with_object([]) do |suit, object|
			VALUES.each do |value|
				object << Card.new(value,suit)
			end
		end.shuffle	
	end
end