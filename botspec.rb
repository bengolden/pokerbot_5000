require_relative "poker_bot"

class PokerGame
	
	describe 'create a new game' do
	let(:game) {PokerGame.new}

		it 'has six players' do
			expect(game.players.length).to eq(6)
		end
		it 'has a deck' do
			expect(game.deck.length).to eq(52)
		end
		it 'deck is an array' do
			expect(game.deck.class).to eq(Array)
		end

		let(:game2) {PokerGame.new}
		it 'has a shuffled deck' do
			expect(game.deck).not_to eq(game2.deck)
		end

	end

	describe 'deal preflop' do
		let(:game) {PokerGame.new}

		it 'deals players two cards preflop' do
			expect{game.deal_preflop}.to change{game.players[0].hand.card_count}.by(2)
		end

		it 'dealing preflop decreases the size of the deck' do
			expect{game.deal_preflop}.to change{game.deck.length}.by(-12)			
		end
	end

	describe 'deal flop' do
		let(:game) {PokerGame.new}
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
		let(:game) {PokerGame.new}
		it 'the board grows' do 
			expect{game.deal_turn}.to change{game.board.length}.by(1)
		end
		it 'decreases the size of the deck' do
			expect{game.deal_turn}.to change{game.deck.length}.by(-1)			
		end
	end

	describe 'deal river' do
		let(:game) {PokerGame.new}
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
	let(:game) {PokerGame.new}
  let(:player1) {PokerPlayer.new}
  let(:player2) {PokerPlayer.new}
  let(:player3) {PokerPlayer.new}
  let(:player4) {PokerPlayer.new}
  let(:player5) {PokerPlayer.new}
  let(:player6) {PokerPlayer.new}
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


end