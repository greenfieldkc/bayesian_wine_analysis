class Index < BayesNetwork
  
  def initialize
  end
  
  def find_characteristic_cpds_from_topics text_data
    wine_topic_dist = run_topic_model(text_data)
    for each feature 
      temp1 = wine_topic_dist.reduce_to feature
      temp2 = characteristic_dist_by_topic.reduce_to feature
      index_feature_cpd = factor temp1, temp2
      index_feature_cpd.marginalize
  end
  
  def run_topic_model text_data
  end
  
end


class Wine < Index
  :alcohol, :winery, :vintage, :varietal, :nickname, :location
end

class User < Index
  :name, :email, :password
end