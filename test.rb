require 'lda-ruby'

corpus = Lda::Corpus.new
corpus.add_document(Lda::TextDocument.new(corpus, "a lion is a wild feline animal"))
corpus.add_document(Lda::TextDocument.new(corpus, "a dog is a friendly animal"))
corpus.add_document(Lda::TextDocument.new(corpus, "a cat is a feline animal"))
lda = Lda::Lda.new(corpus)
lda.verbose = false
lda.num_topics = (2)
lda.em('random')
topics = lda.top_words(3)

print lda
print topics