require_relative 'cards'
require_relative 'store'
require_relative 'collection'

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

	def buyPack
		@collection.addPack(@store.buyPack)

		ex_dust, n_ex = @collection.disenchantExtras
		g_dust, n_g = @collection.disenchantGoldens

		@dust += ex_dust + g_dust
		@disenchanted += n_ex + n_g

		@dust, c = @collection.craftRarest(@dust)
		@crafted += c
		new_cards = Store::CARDS_PER_PACK + c - (n_ex + n_g)
		@cards += new_cards
		@cards_record.push(@cards)
		@purchased += 1
		return new_cards
	end

	def complete?
		@cards >= COMPLETE_COLLECTION
	end

	def run
		while !@collection.complete?
			buyPack
		end
	end
end