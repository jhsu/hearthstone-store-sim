require_relative 'cards'

class Store
	RARITIES = [:common, :rare, :epic, :legendary]
	
	GOLDEN_RARITIES = {
		common: :golden_common,
		rare: :golden_rare,
		epic: :golden_epic,
		legendary: :golden_legendary
	}

	P_RARITY = {
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

	def makeCard(rarity)
		case rarity
		when :common
			CommonCard.rand
		when :rare
			RareCard.rand
		when :epic
			EpicCard.rand
		when :legendary
			LegendaryCard.rand
		when :golden_common
			GoldenCommonCard.rand
		when :golden_rare
			GoldenRareCard.rand
		when :golden_epic
			GoldenEpicCard.rand
		when :golden_legendary
			GoldenLegendaryCard.rand
		else
			raise "unrecognized rarity"
		end
	end

	def randomRarity
		r = Random.rand
		for rarity in RARITIES
			if r < P_RARITY[rarity]
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
		if golden
			makeCard(GOLDEN_RARITIES[rarity])
		else
			makeCard(rarity)
		end
	end

	def randomRare
		rarity = :rare
		golden = randomGold(rarity)
		if golden
			makeCard(GOLDEN_RARITIES[rarity])
		else
			makeCard(rarity)
		end
	end

	def buyPack
		pack = Array.new(5)
		pack[0] = randomCard
		pack[1] = randomCard
		pack[2] = randomCard
		pack[3] = randomCard
		contains_rare = pack[0..3].any? {|card| atLeastRare? card}
		if !contains_rare
			pack[4] = randomRare
		else
			pack[4] = randomCard
		end
		pack
	end
end