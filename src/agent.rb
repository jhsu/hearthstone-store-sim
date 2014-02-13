require_relative 'cards'
require_relative 'store'
require_relative 'collection'

class Agent
	attr_reader :collection
	attr_reader :purchased
	attr_reader :disenchanted
	attr_reader :crafted

	def initialize
		@collection = CardCollection.new
		@store = Store.new
		@dust = 0
		@disenchanted = 0
		@crafted = 0
		@cards = 0
	end

	def buyPack
		@collection.addPack(@store.buyPack)

		ex_dust, n_ex = @collection.disenchantExtras
		g_dust, n_g = @collection.disenchantGoldens

		@dust += ex_dust + g_dust
		@disenchanted += n_ex + n_g

		@dust, c = @collection.craftRarest(@dust)
		@crafted += c
		@cards += Store::CARDS_PER_PACK + c - (n_ex + n_g)
	end

	def complete?
		@cards < TOTAL_UNIQUE_CARDS
	end

	def run
		while !@collection.complete?
			buyPack
		end
	end
end