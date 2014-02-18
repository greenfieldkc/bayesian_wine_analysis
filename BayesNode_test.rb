require './BayesMethods.rb'

class BayesNode
  attr_accessor :name, :label, :observed, :parents, :children
  include BayesMethods
  def initialize name, label, options = {}
    options = {
      :observed => false,
      :parents  => [],
      :children => []
    }.merge(options)
    @name = name ; @label = label ; @children = children ; @parents = parents ; @observed = observed
    get_flow_of_independence
    set_gradient_cpd
  end
  
  def add_child child_name
    @children << child_name
    child_name.add_parent self
  end
  
  def add_parent parent_name
    @parents << parent_name
  end
  
  def get_flow_of_independence
    @parent_to_child = @observed == false ? true : false
    @child_to_parent = @observed == false ? true : false
    @child_to_child = @observed == false ? true : false
    @v_structure = @observed == false ? false : true
  end  
  
  def has_child? child_name
    return true if @children.include child_name
  end
  
  def has_parent? parent_name
    return true if @parents.include parent_name
  end
  
  def set_gradient_cpd hash={0 => 0.5, 1 => 0.5}
    @gradient_cpd = hash
  end
    
end

def main
test = BayesNode.new('name', 'label')
puts test, test.name, test.label, test.parents
test_parent = BayesNode.new 'name_parent', 'label_parent', :children => test
#BayesMethods.factor(test.gradient_cpd, test_parent.gradient_cpd)


end

main