require('ggplot2')
require('reshape2')

cards = read.csv('../data/cards.csv')
cards_long = melt(cards, id.vars="Packs", value.name="Cards", variable.name="Agent")
ggplot(data=cards_long, aes(x=Packs, y=Cards, group=Agent, colour=Agent)) + geom_line()
