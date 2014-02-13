require_relative 'cards'

class CardCollection
	def initialize
		@cards = Array.new(2 * TOTAL_UNIQUE_CARDS) do |i|
			if i < RareCard::OFFSET
				CommonCard.new
			elsif i < EpicCard::OFFSET
				RareCard.new
			elsif i < LegendaryCard::OFFSET
				EpicCard.new
			elsif i < GoldenCommonCard::OFFSET
				LegendaryCard.new
			elsif i < GoldenRareCard::OFFSET
				GoldenCommonCard.new
			elsif i < GoldenEpicCard::OFFSET
				GoldenRareCard.new
			elsif i < GoldenLegendaryCard::OFFSET
				GoldenEpicCard.new
			else
				GoldenLegendaryCard.new
			end
		end
	end

	def numCards
		@cards.reduce(0) {|memo, card| memo += card.copies}
	end

	def addPack(pack)
		pack.each do |card|
			@cards[card].addCopy
		end
	end

	def complete?
		@cards[0..TOTAL_UNIQUE_CARDS-1].all? { |card| card.complete? }
	end

	def goldenComplete?
		@cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1].all? { |card| card.complete? }
	end

	def completion
		@cards[0..TOTAL_UNIQUE_CARDS-1].reduce(0) {|memo, card| card.complete? ? memo + 1 : memo} / TOTAL_UNIQUE_CARDS.to_f
	end

	def goldenCompletion?
		@cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1].reduce(0) {|memo, card| card.complete? ? memo + 1 : memo} / TOTAL_UNIQUE_CARDS.to_f
	end

	def disenchantExtras
		dust = 0
		n = 0
		for card in @cards
			extras = card.removeExtras
			dust += card.disenchant_value * extras
			n += extras
		end
		return dust, n
	end

	def disenchantGoldens
		dust = 0
		n = 0
		for card in @cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1]
			extras = card.removeAll
			dust += card.disenchant_value * extras
			n += extras
		end
		return dust, n
	end

	def craft(dust, cards)
		n = 0
		for card in cards
			if !card.complete?
				missing = card.numMissing
				if missing * card.craft_cost <= dust
					dust -= missing * card.craft_cost
					card.addCopies(missing)
					n += missing
				elsif card.craft_cost <= dust
					dust -= card.craft_cost
					card.addCopy
					n += 1
					break
				else
					break
				end
			end
		end
		return dust, n
	end

	def craftRarest(dust)
		if complete? 
			craft(dust, @cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1].reverse)
		else
			craft(dust, @cards[0..TOTAL_UNIQUE_CARDS-1].reverse)
		end
	end
end