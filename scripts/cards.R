require('ggplot2')
require('reshape2')

cards = read.csv('../data/cards.csv')

# plot all of the runs
cards_long = melt(cards, id.vars="Packs", value.name="Cards", variable.name="Agent")
ggplot(data=cards_long, aes(x=Packs, y=Cards, group=Agent, colour=Agent)) + geom_line()

# drop the packs column
drops <- c("Packs")
cards2 <- cards[,!(names(cards) %in% drops)]

# plot the mean of the runs
cards_mean = rowSums(cards2) / ncol(cards2)
qplot(1:length(cards_mean), cards_mean)

# compute the marginal cost of each new card
cards_diff <- diff(cards_mean) # number of new cards per pack
cards_marg <- 1.25 / cards_diff # assuming we buy cards at $50/40 packs, we get $1.25/pack
qplot(1:512, cards_marg[1:512]) # data gets a little noisy beyond 500