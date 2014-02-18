require './BayesNode_test.rb'
require './standalone_test_2.rb'

def main
  wine0123 = BayesNode.new('wine', 'w', 1 )
  topic0123 = BayesNode.new('topic', 'x', 3 )
  fruit0123 = BayesNode.new('fruit', 'f', 3 )
  tannin0123 = BayesNode.new('tannin', 't', 3 )
  
  topic_fruit_cpd = CPD.new
  topic_fruit_cpd['x0-f0'] = 0.2
  topic_fruit_cpd['x0-f1'] = 0.3
  topic_fruit_cpd['x0-f2'] = 0.5
  topic_fruit_cpd['x1-f0'] = 0.3
  topic_fruit_cpd['x1-f1'] = 0.3
  topic_fruit_cpd['x1-f2'] = 0.4
  topic_fruit_cpd['x2-f0'] = 0.6
  topic_fruit_cpd['x2-f1'] = 0.1
  topic_fruit_cpd['x2-f2'] = 0.3
  
  topic0123.add_child(fruit0123, topic_fruit_cpd)
end

main