require './BayesMethods.rb'
require 'pry'

class TopicModelServer
  def get_features_for

    wtf_array = [[0.2, [0.4,0.3,0.3]], [0.5, [0.4, 0.1, 0.5]], [0.3, [0.2, 0.1, 0.7]]]

    wine_topic = CPD.new ; topic_feature = CPD.new

    0.upto(wtf_array.length - 1).each do |i|
      wine_topic["t#{i}"] = wtf_array[i][0]
      0.upto(wtf_array[i][1].length - 1).each do |x|
        topic_feature["t#{i}-f#{x}"] = wtf_array[i][1][x]
      end
    end
    
  puts wine_topic
  puts topic_feature
  puts
  puts
  factored = BayesMethods.factor(wine_topic, topic_feature)
  puts "factored" , factored 
  marginalized = BayesMethods.marginalize(factored, "t")
  puts marginalized
  end
end

def main
  #test = TopicModelServer.new
  #test.get_features_for
  
  user_feature_cpd = {"f0" => 0.03, "f1" => 0.1, "f2" => 0.6, "f3" => 0.8 }
  wine_feature_cpd = {"f0" => 0.01, "f1" => 0.2, "f2" => 0.5, "f3" => 0.2 }

  p "user: #{user_feature_cpd.inspect}"
  p "wine: #{wine_feature_cpd.inspect}"

  wine_list = {
    'wine1' => { "f0" => 0.1, "f1" => 0.2, "f2" => 0.5, "f3" => 0.2 },
    'wine2' => { "f0" => 0.4, "f1" => 0.2, "f2" => 0.1, "f3" => 0.3 },
    'wine3' => { "f0" => 0.3, "f1" => 0.2, "f2" => 0.7, "f3" => 0.4 }
  }
  
  p "wine_list: #{wine_list.inspect}"
  
  recommendations = recommend_wines user_feature_cpd, wine_list
  
  p recommendations
end

# def main
#   topic_model_server = TopicModelServer.new
# 
#   #foreach wine in the dB,
#   #  get the winemaker notes
#   #  ask the topic_model server for the features for this wine
#   #  store the features CPD back to the dB
#   
#   w1 = Wine.new
#   w1.winemaker_notes = "bitter fruit"
#   
#   w1.features_cpd = topic_model_server.get_features_for(w1.winemaker_notes)  
# end

def find_single_feature_match_simple_distance wine_feature_cpd, user_feature_cpd, key
  1 - (wine_feature_cpd[key] - user_feature_cpd[key]).abs
end

def dot_product cpd_a, cpd_b
  temp = []
  cpd_a.keys.each { |key| temp << cpd_a[key] * cpd_b[key] }
  temp.inject(0) { |sum, i| sum + i }
end

def magnitude cpd_a
  temp = []
  cpd_a.keys.each { |key| temp << cpd_a[key]**2 }
  temp.inject(0) { |sum, i| sum + i }
end
    
def find_global_match_cos_theta wine_feature_cpd, user_feature_cpd 
  (dot_product(wine_feature_cpd, user_feature_cpd)) / (magnitude(wine_feature_cpd) * magnitude(user_feature_cpd))
end

def find_global_match_simple_distance_avg wine_feature_cpd, user_feature_cpd
  temp = []
  wine_feature_cpd.keys.each { |key| temp << find_single_feature_match_simple_distance(wine_feature_cpd, user_feature_cpd, key) }
  temp.inject(0) { |sum, i| sum + i } / temp.length
end

def update_user_palate rank_input, wine_feature_cpd, user_feature_cpd #note: not weighted to account for previously ranked wines
  user_feature_cpd.keys.each do |key| 
    change_value = ((wine_feature_cpd[key] - user_feature_cpd[key]) * rank_input) / 2
    user_feature_cpd[key] = user_feature_cpd[key] + change_value 
  end
end
  
def recommend_wines user_palate, wine_list #user_palate is cpd array; wine_list is hash[wine_name] = wine_feature_cpd
  match_hash = {}
  wine_list.keys.each { |wine| match_hash[wine] = find_global_match_simple_distance_avg(wine_list[wine], user_palate) }
  match_hash.to_a.sort{ |a, b| b[1] <=> a[1] }
#  match_array = []
#  match_hash.values.each { |value| match_array << value }
#  match_array.sort.reverse!
#  match_hash.map { |key, value| value == match_array[0] ? key : nil }.compact.sample
end

  
main
  
  
  
  
  
  
  
