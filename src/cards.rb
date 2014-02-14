# common = 0..93
# rare = 94..174
# epic = 175..211
# legendary = 212..244

# Determine if a card is at least a rare card or better given its id
def atLeastRare?(card_id)
	(card_id >= CommonCard::NUM_UNIQUES and card_id < TOTAL_UNIQUE_CARDS) or # non-golden set
		(card_id >= TOTAL_UNIQUE_CARDS + CommonCard::NUM_UNIQUES and card_id < 2 * TOTAL_UNIQUE_CARDS) # golden set
end

# Base class of all other cards. Each Card object keeps track of how many copies
# of it are in your collection.
class CardBase
	attr_reader :disenchant_value
	attr_reader :craft_cost
	attr_reader :num_uniques
	attr_reader :copies
	attr_reader :max_copies

	def initialize
		@copies = 0
	end

	# Add a new copy
	def addCopy
		@copies += 1
	end

	# Add n new copies
	def addCopies(n)
		@copies += n
	end

	# Remove a copy, if possible
	def removeCopy
		if @copies > 0
			@copies -= 1
		end
		@copies
	end

	# Remove all extras
	def removeExtras
		n = numExtras
		@copies -= n
		n
	end

	# Remove all copies
	def removeAll
		@copies, n = 0, @copies
		return n
	end

	# Test if we have reached or exceeded the maximum number of copies
	def complete?
		@copies >= @max_copies
	end

	# Test if we have exceeded the maximum number of copies
	def extras?
		@copies > @max_copies
	end

	# Calculate the number of extra copies
	def numExtras
		extras? ? @copies - @max_copies : 0
	end

	# Calculate the number of copies required to complete this card
	def numMissing
		complete? ? 0 : @max_copies - @copies
	end
end

# Contains data specific to common cards
class CommonCard < CardBase
	OFFSET = 0
	NUM_UNIQUES = 94
	MAX_COPIES = 2

	def initialize
		super
		@disenchant_value = 5
		@craft_cost = 40
		@num_uniques = NUM_UNIQUES
		@max_copies = MAX_COPIES		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to rare cards
class RareCard < CardBase
	OFFSET = CommonCard::OFFSET + CommonCard::NUM_UNIQUES
	NUM_UNIQUES = 81
	MAX_COPIES = 2

	def initialize
		super
		@disenchant_value = 20
		@craft_cost = 100
		@num_uniques = NUM_UNIQUES
		@max_copies = MAX_COPIES		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to epic cards
class EpicCard < CardBase
	OFFSET = RareCard::OFFSET + RareCard::NUM_UNIQUES
	NUM_UNIQUES = 37
	MAX_COPIES = 2

	def initialize
		super
		@disenchant_value = 100
		@craft_cost = 400
		@num_uniques = NUM_UNIQUES
		@max_copies = MAX_COPIES		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to legendary cards
class LegendaryCard < CardBase
	OFFSET = EpicCard::OFFSET + EpicCard::NUM_UNIQUES
	NUM_UNIQUES = 33
	MAX_COPIES = 1

	def initialize
		super
		@disenchant_value = 400
		@craft_cost = 1600
		@num_uniques = NUM_UNIQUES
		@max_copies = MAX_COPIES		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to golden common cards
class GoldenCommonCard < CardBase
	OFFSET = LegendaryCard::OFFSET + LegendaryCard::NUM_UNIQUES
	NUM_UNIQUES = 94

	def initialize
		super
		@disenchant_value = 50
		@craft_cost = 400
		@num_uniques = NUM_UNIQUES
		@max_copies = 2		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to golden rare cards
class GoldenRareCard < CardBase
	OFFSET = GoldenCommonCard::OFFSET + GoldenCommonCard::NUM_UNIQUES
	NUM_UNIQUES = 81

	def initialize
		super
		@disenchant_value = 100
		@craft_cost = 800
		@num_uniques = NUM_UNIQUES
		@max_copies = 2		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to golden epic cards
class GoldenEpicCard < CardBase
	OFFSET = GoldenRareCard::OFFSET + GoldenRareCard::NUM_UNIQUES
	NUM_UNIQUES = 37

	def initialize
		super
		@disenchant_value = 400
		@craft_cost = 1600
		@num_uniques = NUM_UNIQUES
		@max_copies = 2		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Contains data specific to golden legendary cards
class GoldenLegendaryCard < CardBase
	OFFSET = GoldenEpicCard::OFFSET + GoldenEpicCard::NUM_UNIQUES
	NUM_UNIQUES = 33

	def initialize
		super
		@disenchant_value = 1600
		@craft_cost = 3200
		@num_uniques = NUM_UNIQUES
		@max_copies = 1		
	end

	def self.rand
		Random.rand(NUM_UNIQUES-1) + OFFSET
	end
end

# Now that we have all the cards, lets compute some upper bounds on our collection
TOTAL_UNIQUE_CARDS = CommonCard::NUM_UNIQUES + RareCard::NUM_UNIQUES + EpicCard::NUM_UNIQUES + LegendaryCard::NUM_UNIQUES
COMPLETE_COLLECTION = CommonCard::NUM_UNIQUES * CommonCard::MAX_COPIES + RareCard::NUM_UNIQUES * RareCard::MAX_COPIES + EpicCard::NUM_UNIQUES * EpicCard::MAX_COPIES + LegendaryCard::NUM_UNIQUES * LegendaryCard::MAX_COPIES