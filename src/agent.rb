require_relative 'cards'
require_relative 'store'
require_relative 'collection'

# The agent is responsible for running the simulation according to a given set 
# of rules. Currently, these rules are:
# - Buy a new pack and add it to the collection
# - Disenchant any extra cards in the collection
# - Disenchant any rare cards in the collection
# - Craft the rarest incomplete card
# The agent repeats these steps until its collection is complete.
class Agent
	attr_reader :purchased
	attr_reader :disenchanted
	attr_reader :crafted
	attr_reader :cards
	attr_reader :dust
	attr_reader :cards_record

	def initialize
		@collection = CardCollection.new
		@store = Store.new
		@dust = 0
		@disenchanted = 0
		@crafted = 0
		@cards = 0
		@purchased = 0
		@cards_record = Array.new
	end

	# Add a new pack to the collection and take care of extras, goldens, and 
	# crafting.
	def buyPack
		@collection.addPack(@store.buyPack)

		extras_dust, n_extras = @collection.disenchantExtras
		goldens_dust, n_goldens = @collection.disenchantGoldens

		@dust += extras_dust + goldens_dust
		@disenchanted += n_extras + n_goldens

		@dust, n_crafted = @collection.craftRarest(@dust)
		@crafted += n_crafted
		new_cards = Store::CARDS_PER_PACK + n_crafted - (n_extras + n_goldens)
		@cards += new_cards
		@cards_record.push(@cards)
		@purchased += 1
		return new_cards
	end

	# Check if we have completed the non-golden set
	def complete?
		@cards >= COMPLETE_COLLECTION
	end

	# Buy packs until the collection is complete
	def run
		while !@collection.complete?
			buyPack
		end
	end
end