require_relative 'cards'

# The Store handles the task of generating packs of random cards.
class Store
	CARDS_PER_PACK = 5

	RARITIES = [:common, :rare, :epic, :legendary]

	# Probability distributions for each rarity.
	# Taken from: http://iam.yellingontheinternet.com/2013/10/10/from-dust-to-dust-the-economy-of-hearthstone/
	DISTRIBUTION = {
		common: 0.74,
		rare: 0.95,
		epic: 0.99,
		legendary: 1.0
	}

	# Probability of getting a golden version of a card
	P_GOLDEN = {
		common: 0.02, 
		rare: 0.05, 
		epic: 0.05, 
		legendary: 0.05
	}

	# Generate a random card for a given rarity. Make it golden if necessary.
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

	# Pick a random rarity
	def randomRarity
		r = Random.rand
		for rarity in RARITIES
			if r < DISTRIBUTION[rarity]
				return rarity
			end
		end 
	end

	# Determine if a given rarity is a golden version or not
	def randomGold(rarity)
		r = Random.rand
		if r < P_GOLDEN[rarity]
			true
		else
			false
		end
	end

	# Generate a random card of any rarity
	def randomCard
		rarity = randomRarity
		golden = randomGold(rarity)
		makeCard(rarity, golden)
	end

	# Generate a random rare card
	def randomRare
		golden = randomGold(:rare)
		makeCard(:rare, golden)
	end

	# Generate a new pack of random cards. At least one card will be rare or better
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