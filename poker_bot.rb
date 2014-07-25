require_relative "poker_bot_hands"

SUITS = ['s','h','d','c']
VALUES = [2,3,4,5,6,7,8,9,10,11,12,13,14]

class PokerGame
	attr_reader :players, :deck, :board
	def initialize
		@players = []
		@board = []
		6.times do
			@players << PokerPlayer.new
		end
		@deck = []
		SUITS.each do |suit|
			VALUES.each do |value|
				@deck << Card.new(value,suit)
			end
		end
	end

	def deal_preflop
		2.times {deal_to_players}
	end

	def deal_flop
		3.times {deal_community}
	end

	def deal_turn
		deal_community
	end

	def deal_river
		deal_community
	end

	def winner
		winner = [players[0]]
		players[1..5].each do |player|
			player_hand = player.hand
			winner_hand = winner[0].hand


			if player_hand.compare(winner_hand) == 1
				winner = [player]
			elsif player_hand.compare(winner_hand) == 0
				winner << player
			end
		end
		winner
	end
	private

	def deal_community
		@board << @deck.pop
	end
	def deal_to_players
		@players.each do |player|
			player.receive_cards(@deck.pop)
		end
	end

end

class PokerPlayer
	attr_reader :hand
	def initialize(name = "Anon")
		@name = name
		@hand = PokerHand.new([])
	end

	def receive_cards(cards)
		@hand.hand << cards
	end

end