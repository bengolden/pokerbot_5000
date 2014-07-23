require_relative "poker_bot"

class PokerHand
	describe 'evaluate hands' do

	let(:s2) {Card.new(2,"s")}
	let(:s3) {Card.new(3,"s")}
	let(:s4) {Card.new(4,"s")}
	let(:s5) {Card.new(5,"s")}
	let(:d5) {Card.new(5,"d")}
	let(:h5) {Card.new(5,"h")}
	let(:c5) {Card.new(5,"c")}
	let(:s6) {Card.new(6,"s")}
	let(:c9) {Card.new(9,"c")}
	let(:sa) {Card.new(14,"s")}
	let(:ca) {Card.new(14,"a")}

		describe '.straight?' do
			let(:hand1) {PokerHand.new([s2,s3,s4,d5,s6,h5])}
			let(:hand2) {PokerHand.new([s4,s6,s2,d5,s3])}
			let(:wheel) {PokerHand.new([s2,s3,d5,c9,sa,s4])}
			let(:hand3) {PokerHand.new([s2,s3,sa,d5,s6])}
			let(:hand4) {PokerHand.new([s2,s3,s4,d5])}

			it 'returns true if hand is a straight' do
				expect(hand1.straight?).to equal(true)
			end

			it 'returns true if straight is out of order' do
				expect(hand2.straight?).to equal(true)
			end

			it 'returns true if wheel' do
				expect(wheel.straight?).to equal(true)
			end

			it 'returns false if hand is not a straight' do
				expect(hand3.straight?).to equal(false)
			end

			it 'returns false if invalid hand' do
				expect(hand4.straight?).to equal(false)
			end
		end

		describe '.flush?' do
			let(:hand1) {PokerHand.new([c9,s2,s3,s4,s6,sa])}
			let(:hand2) {PokerHand.new([s2,d5,s4,s6,sa])}

			it 'returns true if hand is a flush' do
				expect(hand1.flush?).to equal(true)
			end

			it 'returns false if hand is not a flush' do
				expect(hand2.flush?).to equal(false)
			end
		end		

		describe '.straight_flush?' do
			let(:hand1) {PokerHand.new([s2,s3,c9,s4,s6,s5])}
			let(:hand2) {PokerHand.new([s2,s3,s4,s6,sa])}
			let(:hand3) {PokerHand.new([s4,s6,s2,d5,s3])}

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

		describe '.full_house?' do
			let(:hand1) {PokerHand.new([s5,c5,h5,sa,ca])}
			let(:hand2) {PokerHand.new([s5,c5,h5,sa,d5])}
			it 'returns true if full house' do
				expect(hand1.full_house?).to equal(true)
			end

			it 'returns false if not full house' do
				expect(hand2.full_house?).to equal(false)
			end
		end

		describe '.quads?' do
			let(:hand1) {PokerHand.new([s5,c5,h5,sa,d5])}
			let(:hand2) {PokerHand.new([s5,c5,h5,sa,ca])}
			it 'returns true if full house' do
				expect(hand1.quads?).to equal(true)
			end

			it 'returns false if not full house' do
				expect(hand2.quads?).to equal(false)
			end
		end

		describe '.trips?' do
			let(:hand1) {PokerHand.new([s3,c5,h5,sa,d5])}
			let(:hand2) {PokerHand.new([s3,c5,h5,sa,ca])}
			it 'returns true if trips' do
				expect(hand1.trips?).to equal(true)
			end

			it 'returns false if not trips' do
				expect(hand2.trips?).to equal(false)
			end
		end

		describe '.two_pair?' do
			let(:hand1) {PokerHand.new([s3,c5,h5,sa,ca])}
			let(:hand2) {PokerHand.new([s3,c5,h5,sa,d5])}
			it 'returns true if two pair' do
				expect(hand1.two_pair?).to equal(true)
			end

			it 'returns false if not two pair' do
				expect(hand2.two_pair?).to equal(false)
			end
		end

		describe '.pair?' do
			let(:hand1) {PokerHand.new([s3,s2,h5,sa,ca])}
			let(:hand2) {PokerHand.new([s3,s2,s4,sa,d5])}
			it 'returns true if two pair' do
				expect(hand1.pair?).to equal(true)
			end

			it 'returns false if not two pair' do
				expect(hand2.pair?).to equal(false)
			end
		end

		describe 'return hand description' do
			let(:no_pair)					{PokerHand.new([s3,s2,h5,sa,c9])}
			let(:pair)						{PokerHand.new([s3,s2,h5,sa,ca])}
			let(:two_pair)				{PokerHand.new([s3,c5,h5,sa,ca])}
			let(:trips)						{PokerHand.new([s3,c5,h5,sa,d5])}
			let(:straight)				{PokerHand.new([s4,s6,s2,d5,s3])}
			let(:flush)						{PokerHand.new([s2,s3,s4,s6,sa])}
			let(:full_house) 			{PokerHand.new([s5,c5,h5,sa,ca])}
			let(:quads) 					{PokerHand.new([s5,c5,h5,sa,d5])}
			let(:straight_flush) 	{PokerHand.new([s2,s3,s4,s6,s5])}
			it 'evaluates no pair' do
				expect(no_pair.evaluate)to equal([0,14,9,5,3,2])
			end
			it 'evaluates pair' do
				expect(pair.evaluate)to equal([1,14,5,3,2])
			end
			it 'evaluates two pair' do
				expect(two_pair.evaluate)to equal([2,14,5,3])
			end
			it 'evaluates trips' do
				expect(trips.evaluate)to equal([3,5,14,3])
			end
			it 'evaluates straight' do 
				expect(straight.evaluate)to equal([4,6])
			end
			it 'evaluates flush' do
				expect(flush.evaluate)to equal([5,14,6,4,3,2])
			end
			it 'evaluates full house' do
				expect(flush.evaluate)to equal([6,5,14])
			end
			it 'evaluates quads' do
				expect(flush.evaluate)to equal([7,5,14])
			end
			it 'evaluates straight flush' do
				expect(flush.evaluate)to equal([8,6])
			end
		end
	end
end