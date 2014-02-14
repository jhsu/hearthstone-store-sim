require_relative 'agent'
require 'csv'

agents = Array.new(100) {Agent.new}
while !agents.all? {|agent| agent.complete?}
	agents.each do |agent|
		agent.buyPack
	end
end

if !Dir.exists? '../data'
	Dir.mkdir('../data')
end

CSV.open('../data/cards.csv', 'w') do |csv|
	cols = ["Packs"] + Array.new(100) {|idx| "Agent" + idx.to_s}
	csv << cols
	n = agents[0].cards_record.length
	for i in 0..n-1
		row = [i+1]
		agents.each do |agent|
			row.push(agent.cards_record[i])
		end
		csv << row
	end
end