require_relative 'cards'

# The CardCollection contains instances of each card id and handles the tasks of
# integrating new packs, disenchanting extras, and crafting new cards.
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

	# Count up all copies in the collection
	def numCards
		@cards.reduce(0) {|memo, card| memo += card.copies}
	end

	# Add a new pack of cards to the collection
	def addPack(pack)
		pack.each do |card|
			@cards[card].addCopy
		end
	end

	# Test for completion of all non-golden cards
	def complete?
		@cards[0..TOTAL_UNIQUE_CARDS-1].all? { |card| card.complete? }
	end

	# Test for completion of all golden cards
	def goldenComplete?
		@cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1].all? { |card| card.complete? }
	end

	# Evaluate the percentage completion of the collection (non-golden)
	def completion
		@cards[0..TOTAL_UNIQUE_CARDS-1].reduce(0) {|memo, card| card.complete? ? memo + 1 : memo} / TOTAL_UNIQUE_CARDS.to_f
	end

	# Evaluate the percentage completion of the collection (golden)
	def goldenCompletion?
		@cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1].reduce(0) {|memo, card| card.complete? ? memo + 1 : memo} / TOTAL_UNIQUE_CARDS.to_f
	end

	# Disenchant all extra cards. Returns the dust created from disenchanting and 
	# the number of cards disenchanted.
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

	# Disenchant all golden cards. Returns the dust created from disenchanting and 
	# the number of cards disenchanted.
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

	# Craft the first incomplete card in a given set of cards for a given amount of
	# dust. If it is not possible to craft the card, this function will return, 
	# otherwise it will try to complete the missing card.
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

	# Craft the rarest incomplete card in the non-golden set. If the non-golden set
	# is complete, start on the non-golden set for funsies.
	def craftRarest(dust)
		if complete? 
			craft(dust, @cards[TOTAL_UNIQUE_CARDS..2*TOTAL_UNIQUE_CARDS-1].reverse)
		else
			craft(dust, @cards[0..TOTAL_UNIQUE_CARDS-1].reverse)
		end
	end
end