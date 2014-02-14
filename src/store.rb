require_relative 'cards'

class Store
	CARDS_PER_PACK = 5

	RARITIES = [:common, :rare, :epic, :legendary]

	DISTRIBUTION = {
		common: 0.74,
		rare: 0.95,
		epic: 0.99,
		legendary: 1.0
	}

	P_GOLDEN = {
		common: 0.02, 
		rare: 0.05, 
		epic: 0.05, 
		legendary: 0.05
	}

	def makeCard(rarity, golden)
		case rarity
		when :common
			golden ? GoldenCommonCard.rand : CommonCard.rand
		when :rare
			golden ? GoldenRareCard.rand : RareCard.rand
		when :epic
			golden ? GoldenEpicCard.rand : EpicCard.rand
		when :legendary
			golden ? GoldenLegendaryCard.rand : LegendaryCard.rand
		else
			raise "unrecognized rarity"
		end
	end

	def randomRarity
		r = Random.rand
		for rarity in RARITIES
			if r < DISTRIBUTION[rarity]
				return rarity
			end
		end 
	end

	def randomGold(rarity)
		r = Random.rand
		if r < P_GOLDEN[rarity]
			true
		else
			false
		end
	end

	def randomCard
		rarity = randomRarity
		golden = randomGold(rarity)
		makeCard(rarity, golden)
	end

	def randomRare
		golden = randomGold(:rare)
		makeCard(:rare, golden)
	end

	def buyPack
		pack = Array.new(CARDS_PER_PACK)
		for i in 0..CARDS_PER_PACK-2
			pack[i] = randomCard
		end
		contains_rare = pack[0..CARDS_PER_PACK-2].any? {|card| atLeastRare? card}
		if !contains_rare
			pack[CARDS_PER_PACK-1] = randomRare
		else
			pack[CARDS_PER_PACK-1] = randomCard
		end
		return pack
	end
end