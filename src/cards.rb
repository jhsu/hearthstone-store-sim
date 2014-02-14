# common = 0..93
# rare = 94..174
# epic = 175..211
# legendary = 212..244

def atLeastRare?(card_id)
	(card_id >= CommonCard::NUM_UNIQUES and card_id < TOTAL_UNIQUE_CARDS) or # non-golden set
		(card_id >= TOTAL_UNIQUE_CARDS + CommonCard::NUM_UNIQUES and card_id < 2 * TOTAL_UNIQUE_CARDS) # golden set
end

class CardBase
	attr_reader :disenchant_value
	attr_reader :craft_cost
	attr_reader :num_uniques
	attr_reader :copies
	attr_reader :max_copies

	def initialize
		@copies = 0
	end

	def addCopy
		@copies += 1
	end

	def addCopies(n)
		@copies += n
	end

	def removeCopy
		if @copies > 0
			@copies -= 1
		end
		@copies
	end

	def removeExtras
		n = numExtras
		@copies -= n
		n
	end

	def removeAll
		@copies, n = 0, @copies
		return n
	end

	def complete?
		@copies >= @max_copies
	end

	def extras?
		@copies > @max_copies
	end

	def numExtras
		extras? ? @copies - @max_copies : 0
	end

	def numMissing
		complete? ? 0 : @max_copies - @copies
	end
end

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

TOTAL_UNIQUE_CARDS = CommonCard::NUM_UNIQUES + RareCard::NUM_UNIQUES + EpicCard::NUM_UNIQUES + LegendaryCard::NUM_UNIQUES
COMPLETE_COLLECTION = CommonCard::NUM_UNIQUES * CommonCard::MAX_COPIES + RareCard::NUM_UNIQUES * RareCard::MAX_COPIES + EpicCard::NUM_UNIQUES * EpicCard::MAX_COPIES + LegendaryCard::NUM_UNIQUES * LegendaryCard::MAX_COPIES