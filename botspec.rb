require_relative "poker_bot"

class PokerGame
	
	describe 'create a new game' do
	let(:game) {PokerGame.new({})}

		it 'has six players' do
			expect(game.players.length).to eq(6)
		end
		it 'has a deck' do
			expect(game.deck.length).to eq(52)
		end
		it 'deck is an array' do
			expect(game.deck.class).to eq(Array)
		end

		let(:game2) {PokerGame.new({})}
		it 'has a shuffled deck' do
			expect(game.deck).not_to eq(game2.deck)
		end

	end

	describe 'deal preflop' do
		let(:game) {PokerGame.new({})}

		it 'deals players two cards preflop' do
			expect{game.deal_preflop}.to change{game.players[0].hand.card_count}.by(2)
		end

		it 'dealing preflop decreases the size of the deck' do
			expect{game.deal_preflop}.to change{game.deck.length}.by(-12)			
		end
	end

	describe 'deal flop' do
		let(:game) {PokerGame.new({})}
		it 'the board grows' do 
			expect{game.deal_flop}.to change{game.board.length}.by(3)
		end
		it 'decreases the size of the deck' do
			expect{game.deal_flop}.to change{game.deck.length}.by(-3)			
		end

		before do
	    game.deal_flop
	  end
		it 'the board contains a card' do
			expect(game.board[0].class).to eq(Card)
		end
	end

	describe 'deal turn' do
		let(:game) {PokerGame.new({})}
		it 'the board grows' do 
			expect{game.deal_turn}.to change{game.board.length}.by(1)
		end
		it 'decreases the size of the deck' do
			expect{game.deal_turn}.to change{game.deck.length}.by(-1)			
		end
	end

	describe 'deal river' do
		let(:game) {PokerGame.new({})}
		it 'the board grows' do 
			expect{game.deal_river}.to change{game.board.length}.by(1)
		end
		it 'decreases the size of the deck' do
			expect{game.deal_river}.to change{game.deck.length}.by(-1)			
		end
	end

	describe 'determine winner' do

	let(:s2) {Card.new(2,"s")}
	let(:s3) {Card.new(3,"s")}
	let(:s4) {Card.new(4,"s")}
	let(:s5) {Card.new(5,"s")}
	let(:d5) {Card.new(5,"d")}
	let(:h5) {Card.new(5,"h")}
	let(:c5) {Card.new(5,"c")}
	let(:s6) {Card.new(6,"s")}
	let(:c9) {Card.new(9,"c")}
	let(:ct) {Card.new(10,"c")}
	let(:sa) {Card.new(14,"s")}
	let(:ca) {Card.new(14,"a")}
	let(:sj) {Card.new(11,"s")}
	let(:sq) {Card.new(12,"s")}
	let(:sk) {Card.new(13,"s")}
	let(:game) {PokerGame.new({})}
  let(:player1) {PokerPlayer.new({})}
  let(:player2) {PokerPlayer.new({})}
  let(:player3) {PokerPlayer.new({})}
  let(:player4) {PokerPlayer.new({})}
  let(:player5) {PokerPlayer.new({})}
  let(:player6) {PokerPlayer.new({})}
  let(:hand1) {PokerHand.new([])}
  let(:hand2) {PokerHand.new([])}
  let(:hand3) {PokerHand.new([])}
  let(:hand4) {PokerHand.new([])}
  let(:hand5) {PokerHand.new([])}
  let(:hand6) {PokerHand.new([])}

    it "returns a single winner" do
      game.stub(:players) { [player1,player2,player3,player4,player5,player6] }
     	player1.stub(:hand) {hand1}
     	player2.stub(:hand) {hand2}
     	player3.stub(:hand) {hand3}
     	player4.stub(:hand) {hand4}
     	player5.stub(:hand) {hand5}
     	player6.stub(:hand) {hand6}
     	player1.stub(:id) {1}
     	player2.stub(:id) {2}
     	player3.stub(:id) {3}
     	player4.stub(:id) {4}
     	player5.stub(:id) {5}
     	player6.stub(:id) {6}
     	hand1.stub(:hand) {[d5,h5,sj,sk,sq]}
     	hand2.stub(:hand) {[s2,s3,sj,sk,sq]}
     	hand3.stub(:hand) {[s4,s5,sj,sk,sq]}
     	hand4.stub(:hand) {[c5,s6,sj,sk,sq]}
     	hand5.stub(:hand) {[sa,ca,sj,sk,sq]}
     	hand6.stub(:hand) {[c9,ct,sj,sk,sq]}
			expect(game.winner).to eq([player3])
    end

    it "returns multiple winners" do
      game.stub(:players) { [player1,player2,player3,player4,player5,player6] }
     	player1.stub(:hand) {hand1}
     	player2.stub(:hand) {hand2}
     	player3.stub(:hand) {hand3}
     	player4.stub(:hand) {hand4}
     	player5.stub(:hand) {hand5}
     	player6.stub(:hand) {hand6}
     	hand1.stub(:hand) {[s2,s3,sj,sk,sq,sa,s5]}
     	hand2.stub(:hand) {[s4,c9,sj,sk,sq,sa,s5]}
     	hand3.stub(:hand) {[d5,h5,sj,sk,sq,sa,s5]}
     	hand4.stub(:hand) {[c5,s4,sj,sk,sq,sa,s5]}
     	hand5.stub(:hand) {[s2,ca,sj,sk,sq,sa,s5]}
     	hand6.stub(:hand) {[c9,ct,sj,sk,sq,sa,s5]}
			expect(game.winner.length).to eq(6)
    end
  end

	describe 'deal a new hand' do
	let(:game) {PokerGame.new({ante: 10, big_blind: 40, small_blind: 15})}

		it 'collects blinds and ante' do
			expect{game.begin_hand}.to change{game.players.first.chips}.by(-game.small_blind - game.ante)
		end
		it 'deals cards' do
			expect{game.begin_hand}.to change{game.deck.length}.by(game.players.length * (-2))
		end
		it 'makes all players active' do
			expect{game.begin_hand}.to change{game.players_in_hand}.to(6)
		end
		# it 'sets current bet to zero' do
		# 	expect{game.begin_hand}.to change{game.current_bet}.to(0)
		# end


	end

	describe 'correctly process bets' do
	let(:game) {PokerGame.new({ante: 10, big_blind: 40, small_blind: 15})}
		context 'blinds and ante' do
			it 'collects blinds and ante' do
				expect{game.post_blinds_and_ante}.to change{game.players.first.chips}.by(-game.small_blind - game.ante)
			end
			it 'adds blinds and ante to the pot' do
				expect{game.post_blinds_and_ante}.to change{game.pot}.by(game.small_blind + game.big_blind + game.ante * game.players.length)
			end		
			it 'sets current bet after blinds' do
				expect{game.post_blinds_and_ante}.to change{game.current_bet}.to(game.big_blind)
			end
			it 'sets minimum bet after blinds' do
				expect{game.post_blinds_and_ante}.to change{game.min_bet}.to(game.big_blind)
			end
		end
		context 'calling bets' do
			it 'collects a call' do
	     	game.stub(:current_bet) {40}
				expect{game.receive_call(2)}.to change{game.pot}.by(40)
			end
			it 'collects a call when player has previously bet' do
	     	game.stub(:current_bet) {40}
	     	game.players[2].stub(:last_bet) {15}
				expect{game.receive_call(2)}.to change{game.players[2].chips}.by(-25)
			end
			it 'adds a call to the pot' do
	     	game.stub(:current_bet) {40}
	     	game.players[2].stub(:last_bet) {10}
				expect{game.receive_call(2)}.to change{game.pot}.by(30)
			end
			it 'updates a players last bet after calling' do
	     	game.stub(:current_bet) {40}
				expect{game.receive_call(2)}.to change{game.players[2].last_bet}.to(40)
			end
		end
		context 'folding' do
			it 'processess a fold' do
				game.begin_hand
				expect{game.receive_fold(2)}.to change{game.players[2].in_hand?}.to(false)
			end
			it 'updates the number of players in the hand' do
				game.begin_hand
				expect{game.receive_fold(2)}.to change{game.players_in_hand}.by(-1)
			end
		end
	end


end