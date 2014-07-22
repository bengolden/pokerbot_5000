require_relative "poker_bot"

class PokerHand

	describe 'evaluate hands' do

	let(:card1) {Card.new(2,"s")}
	let(:card2) {Card.new(3,"s")}
	let(:card3) {Card.new(4,"s")}
	let(:card4) {Card.new(5,"d")}
	let(:card5) {Card.new(6,"s")}
	let(:card6) {Card.new(8,"s")}

		describe '.straight?' do

			let(:hand1) {PokerHand.new([card1,card2,card3,card4,card5])}
			let(:hand2) {PokerHand.new([card1,card2,card4,card5,card6])}
			let(:hand3) {PokerHand.new([card3,card5,card4,card1,card2])}
			let(:hand4) {PokerHand.new([card3,card5,card4,card1])}
			it 'returns true if hand is a straight' do
				expect(hand1.straight?).to equal(true)
			end

			it 'returns false if hand is not a straight' do
				expect(hand2.straight?).to equal(false)
			end

			it 'returns true if straight is out of order' do
				expect(hand3.straight?).to equal(true)
			end

			it 'returns false if invalid hand' do
				expect(hand4.straight?).to equal(false)
			end
		end

		describe '.flush?' do
			let(:hand1) {PokerHand.new([card1,card2,card3,card5,card6])}
			let(:hand2) {PokerHand.new([card1,card2,card4,card5,card6])}

			it 'returns true if hand is a flush' do
				expect(hand1.flush?).to equal(true)
			end

			it 'returns false if hand is not a flush' do
				expect(hand2.flush?).to equal(false)
			end
		end		

		describe '.straight_flush?' do
			let(:card7) {Card.new(5,"s")}
			let(:hand1) {PokerHand.new([card1,card2,card3,card7,card5])}
			let(:hand2) {PokerHand.new([card1,card2,card3,card5,card6])}
			let(:hand3) {PokerHand.new([card3,card5,card4,card1,card2])}

			it 'returns true if straight and flush' do
				expect(hand1.straight_flush?).to equal(true)
			end

			it 'returns false if only flush' do
				expect(hand2.straight_flush?).to equal(false)
			end

			it 'returns false if only straight' do
				expect(hand3.straight_flush?).to equal(false)
			end
		end
	end

end