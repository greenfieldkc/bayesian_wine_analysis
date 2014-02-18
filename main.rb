require 'lda-ruby'

corpus = Lda::Corpus.new
corpus.add_document(Lda::TextDocument.new(corpus, @wine1))
corpus.add_document(Lda::TextDocument.new(corpus, @wine2))
corpus.add_document(Lda::TextDocument.new(corpus, @wine3))
corpus.add_document(Lda::TextDocument.new(corpus, @wine4))

lda = Lda::Lda.new(corpus)
lda.verbose = false
lda.num_topics = (2)
lda.em('random')
topics = lda.top_words(3)

print lda
print topics

@wine1 = "Arista Winery:
2008 Sonoma County Pinot Noir
Meant to be a go-to, everyday Pinot Noir, the 2008 Sonoma County blend begins with ripe plum and stone fruit aromas as well as subtle spice like nutmeg or sandalwood. A refined and silky wine with delicate flavors of licorice, dry cherries, orange zest, and cola. The wine has a medium body or weight on the palate. Long hang time in our cool climate is evidenced by the rich and textured layers of tannins and fruit. Elegant and balanced, this wine is ready to drink upon release. "

@wine2 = "Russian Hill Estate
2008 Russian River Valley Pinot Noir

A standout vintage for our Russian River Valley Pinot noir, the 2008 has an enticing nose of orange zest, cinnamon, cloves and plums. On the palate there are additional flavors of black cherry and sassafras. The wine is racy with a nice sense of zip due to its refreshing acidity. Well integrated tannins give the wine a nice structure and balance.

 91 pts, PinotReport: rich, ripe, cherry fruit with nice spice tones; silky texture, good structure and balance.  Bright, spicy Pinot that is perfect for all occasions. Smart Buy!
1 puff, Connoisseurs' Guide: well focused; has the depth to age well
Wine Specs
Vintage2008
VarietalPinot Noir
AppellationRussian River Valley
Harvest DateThe vineyards comprising this wine were harvested from August 28 through September 12, 2008.
Aging100% French, 30% new barrels for 10 months
Bottling DateJuly 8, 2009
Alcohol %14.5
Wine Profile

Vineyard NotesWe select fruit for our RRV Pinot noir from several small, hands-on growers located throughout the Russian River Valley in order to create a wine that represents our appellation as a whole. The fog-cooled climate and rich alluvial soils of the Russian River Valley provide the perfect conditions for growing Pinot noir. The appellation lies in an area of maximal summer coastal fog incursion providing temperate days and very cool nights resulting in wines with a bright natural acidity and full fruit flavor development due to the slow ripening and long hang times.
Production NotesThe 2008 growing season was remarkable for a very cold and very dry spring requiring frequent use of frost protection systems. The summer fogs were less frequent than normal producing somewhat warmer weather and therefore some earlier harvests.
Winemaker NotesAfter sorting, the grapes were gently destemmed into small, custom designed open top fermenters and kept below 50F for a five day cold soak. Tanks were then individually warmed to allow fermentation to take place in a timely manner followed by cooling as needed to maintain temperatures below 85F. Thrice daily pneumatic punch downs took place during the cold soak and fermentation. Once dry, the wine was gently pressed in a membrane press keeping free run and press fractions separate. Malolactic fermentation took place in oak barrels.
Food Pairing NotesAlmost everything! This is the universal wine.
Production1834 cases"

@wine3 = "Hook and Ladder Winery. 2010 Pinot Noir. We use old world techniques to make our Pinot Noir in small batches and punch-down the fruit by hand up to three times a day. Cecil De Loach has been farming these delicate Pinot Noir vineyards since 1973 in the Russian River Valley. Located on the plains and gently rolling hills off Olivet road in western Santa Rosa, this area provides an excellent medium for the coastal fog that blankets our fruit in the mornings and evenings. The cooling moisture facilitates a longer growing season in which Pinot Noir thrives. Winemaker: Jason De Loach 2900 cases Alcohol: 14.2%"
@wine4 = "La Crema Winery
2010 Arroyo Secco Pinot Noir
In our first single-vineyard bottling from Arroyo Seco, concentrated aromas of black currant, dark plum, anise and tea leaf emerge from the glass. Flavors of blackberry and pomegranate join in on a palate that is at once fresh and ripe. Earthy mineral tones and velvety, plush tannins lead to a long, silky finish.
- Elizabeth Grant-Douglas, Winemaker


Arroyo Seco
COMPOSITION
100% Pinot Noir
TIME IN BARREL
9 months
T.A.
0.52g / 100ml
pH
3.71
ALC. BY VOL.
15.0%"