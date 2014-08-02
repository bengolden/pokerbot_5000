require_relative "poker_bot_hands"

class PokerGame
	attr_reader :players, :deck, :board, :small_blind, :big_blind, :ante, :pot, :min_bet, :current_bet
	def initialize(args)
		@players = args[:players] || []
		@board = []
		6.times do
			@players << PokerPlayer.new({})
		end
		@deck = new_deck
		@small_blind = args[:small_blind] || 25
		@big_blind = args[:big_blind] || 50
		@ante = args[:ante] || 0
		@pot = 0
		@min_bet = 0
		@current_bet = 0
	end

	def begin_hand
		@players.each{|player| player.in_hand = true}
		post_blinds_and_ante
		deal_preflop
	end

	def post_blinds_and_ante
		@pot += @players.first.post_blind(small_blind)
		@pot += @players[1].post_blind(big_blind)
		@players.each{|player| @pot += player.post_ante(ante)} if ante > 0
		@current_bet = big_blind
		@min_bet = big_blind
	end

	def receive_call(index)
		@pot += @players[index].call(current_bet)
	end

	def receive_fold(index)
		@players[index].fold
	end

	def players_in_hand
		players.select{|player| player.in_hand?}.length
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

	def new_deck
		PokerDeck.deal
	end

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
	attr_reader :hand, :chips, :last_bet
	attr_writer :in_hand
	def initialize(args)
		@name = args[:name] || "Anon"
		@chips = args[:chips] || 1000
		@hand = PokerHand.new([])
		@last_bet = 0
		@in_hand = false
	end

	def receive_cards(cards)
		@hand.hand << cards
	end


	def post_blind(blind)
		@chips -= blind
		blind
	end

	def post_ante(ante)
		@chips -= ante
		ante
	end

	def call(current_bet)
		call_size = current_bet - last_bet
		@chips -= call_size
		@last_bet	 = call_size
		call_size
	end

	def fold
		@in_hand = false
	end

	def in_hand?
		@in_hand
	end

end

# john = PokerPlayer.new("John")
# james = PokerPlayer.new("James")
# jill = PokerPlayer.new("Jill")
# jeff = PokerPlayer.new("Jeff")
# jenna = PokerPlayer.new("Jenna")
# joan = PokerPlayer.new("Joan")

# game = PokerGame.new([john,james,jill,jeff,jenna,joan])
# game.deal_preflop
# game.deal_flop
# game.deal_turn
# game.deal_river
# p game.winner