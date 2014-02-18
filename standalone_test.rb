require 'pp'

#-------------------------------------------------
# Define the Models
#-------------------------------------------------
class Wine
  attr_accessor :name, :topic_dist
  def initialize(obj)
    @name       = obj[:name]
    @topic_dist = obj[:topic_dist].clone
  end
end

class Topic
  attr_accessor :name, :fruit_level, :tannin_level
  def initialize(obj)
    @name         = obj[:name]
    @fruit_level  = obj[:fruit_level].clone
    @tannin_level = obj[:tannin_level].clone
  end
end
#-------------------------------------------------


#-------------------------------------------------
#  G   L   O   B   A   L   S
#-------------------------------------------------
$wines  = {}
$topics = {}
#-------------------------------------------------


#-------------------------------------------------
# Main Program Definition
#-------------------------------------------------
def main
  populate_collections

  w0 = $wines['wine_0']
  t0 = $topics['topic_0']
  t1 = $topics['topic_1']

  # P(C | Wi Ti)
  result = {}

  w0.topic_dist.each_with_index { |topic_distribution, index|
     ti = $topics["topic_#{index}"]

     tmp_obj = {}
     
     tmp_obj[:fruit_level]  = ti.fruit_level.map  { |c| c * topic_distribution }
     tmp_obj[:tannin_level] = ti.tannin_level.map { |c| c * topic_distribution }
     
     result["topic_#{index}"] = tmp_obj
  }
  
  pp result
end

def populate_collections
  $topics['topic_0'] = Topic.new(:name => 'topic_0', :fruit_level => [ 0.2, 0.4, 0.4 ], :tannin_level => [ 0.6, 0.3, 0.1])
  $topics['topic_1'] = Topic.new(:name => 'topic_1', :fruit_level => [ 0. 1, 0.8, 0.1 ], :tannin_level => [ 0.8, 0.1, 0.1] )

  $wines['wine_0'] = Wine.new(:name => 'wine_0', :topic_dist => [0.2, 0.8])
end


# Execute the "main" method (Always keep this at the end of the file)
main

wine1_topic_dist = {} ; wine1_topic_dist[['top0']] = 0.2 ; wine1_topic_dist[['top1']] = 0.8
topic0_fruit_dist = {} ; topic0_fruit_dist[['f0']] = 0.2 ; topic0_fruit_dist[['f1']] = 0.4 ; topic0_fruit_dist[['f2']] = 0.4
topic1_fruit_dist = {} ; topic1_fruit_dist[['f0']] = 0.1 ; topic1_fruit_dist[['f1']] = 0.8 ; topic1_fruit_dist['f2'] = 0.1

wine1_topic_dist = {} ; wine1_topic_dist['t0'] = 0.2 ; wine1_topic_dist['t1'] = 0.8
topic_dist = {} ; topic_dist[['w0', 't0']] = 0.2 ; topic_dist[['w0', 't1']] = 0.8 ; topic_dist[['w1','t0']] = 0.3 ; topic_dist[['w1', 't1']] = 0.7
fruit_dist = {} ; fruit_dist[['t0', 'f0']] = 0.2 ; fruit_dist[['t0', 'f1']] = 0.4 ; fruit_dist[['t0', 'f2']] = 0.4
fruit_dist[['t1', 'f0']] = 0.1 ; fruit_dist[['t1', 'f1']] = 0.8 ; fruit_dist[['t1', 'f2']] = 0.1

def factor_product(phi1, phi2) #accepts 2 joint distributions as hashes key is array, value is number
  new_joint_dist = {}
  phi1.keys.each do |phi1_key|
    phi2.keys.each do |phi2_key|
      new_joint_dist[(phi1_key + phi2_key)] = phi1[phi1_key] * phi2[phi2_key]
    end
  end
  return new_joint_dist
  print new_joint_dist
end

def normalize(dist) #normalizes a hash distribution over 1
  sum = 0
  dist.values.each { |value| sum += value }
  dist = dist.values.each { |value| value = value/sum }
end

def marginalize(dist, instance)
  new_dist = {}
end

##note: need to name these into new variables upon return

def reduce(dist, instance) #reduces out instance from distribution 
  new_dist = {} ; dist.keys.each { |key| if key.include?(instance) == false ; new_dist[key] = dist[key] end }
  return new_dist
end