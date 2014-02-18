class CPD < Hash
  def to_s
    each do |key, value|
      printable_value = "%0.2f" % value
      puts "#{key}: #{printable_value}"
    end
  end
end

module BayesMethods
  # Should return error if same # of gradients do not exist for a feature label in both cpds
  def self.factor(cpd_a, cpd_b)
    common_labels                 = find_common_feature_labels(cpd_a, cpd_b) 
    gradients_for_common_features = find_gradients_for_common_features_in_cpd(cpd_a, common_labels)
    reduced_tables                = gradients_for_common_features.map { |gradient| [reduce_to(cpd_a, gradient), reduce_to(cpd_b, gradient) ] }

    result = CPD.new
    
    reduced_tables.each { |table|
      table[0].each { |key_a, value_a|
        table[1].each { |key_b, value_b|
          new_key = construct_new_cpd_key(key_a, key_b)
          result[new_key] = value_a * value_b
        }
      }
    }

    result
  end
  
  def self.marginalize(cpd, feature_label)
    result = CPD.new
    cpd.group_by { |key, value| key.gsub(/#{feature_label}\d+[-]*/, '') }.each { |key, value|
      result[key] = value.inject(0.0) { |acc, tuple| acc = acc + tuple[1]; acc }
    }
    result
  end

  def self.find_common_feature_labels(cpd_a, cpd_b)
    cpd_a_feature_labels = cpd_a.keys.map { |key| key.split('-').map { |feature| feature.split(/\d/)[0] } }.flatten.uniq!
    cpd_b_feature_labels = cpd_b.keys.map { |key| key.split('-').map { |feature| feature.split(/\d/)[0] } }.flatten.uniq!
    cpd_a_feature_labels & cpd_b_feature_labels
  end

  def self.find_gradients_for_common_features_in_cpd(cpd, labels)
    labels.map { |feature_label|
      cpd.keys.map { |key| 
        key.split('-').reject { |feature| feature.match(feature_label).nil? } 
      }.flatten.uniq
    }.flatten
  end

  def self.construct_new_cpd_key(key_a, key_b)
    (key_a.split('-') + key_b.split('-')).uniq.join('-')
  end

  # This elimates the features from the CPD
  def self.reduce_by(src_cpd, features)
    result_cpd = CPD.new
    src_cpd.each { |key, value| result_cpd[key] = value unless contains_features?(key, features) }
    result_cpd
  end

  def self.contains_features?(key_str, features)
    key_str.split('-').each { |key|
      return true if features.include? key
    }
    false
  end

  # This eliminates all the features except for the given features
  def self.reduce_to(src_cpd, features)
    result_cpd = CPD.new
    src_cpd.each { |key, value| result_cpd[key] = value if contains_features?(key, features) }
    result_cpd
  end

  def self.normalize(cpd)
    sum = cpd.values.inject(0.0) { |acc, value| acc = acc + value }
    cpd.each { |key, value| cpd[key] = value/sum }
    cpd
  end
end

  # def self.get_wine_feature_cpd(wine_cpd, topic_cpd, feature)
  #    factor_cpd = BayesMethods.factor(wine_cpd, topic_cpd)
  #    marginalized_cpd = BayesMethods.marginalize(factor_cpd, 'x')
  #    reduced_cpd = BayesMethods.reduce_to(marginalized_cpd, feature)
  #    reduced_cpd
  #  end
  
  def self.prob_user_likes_wine_feature(user_label, wine_label, wine_feature_cpd, user_feature_cpd)
    result = CPD.new
    result = BayesMethods.factor(wine_feature_cpd, user_feature_cpd)
    puts result
  end
  
def main
  wine_topic = CPD.new
  
  wine_topic['w0-x0'] = 0.3
  wine_topic['w0-x1'] = 0.7
  wine_topic['w1-x0'] = 0.4
  wine_topic['w1-x1'] = 0.6

  topic_fruit = CPD.new
  
  topic_fruit['x0-f0'] = 0.2
  topic_fruit['x0-f1'] = 0.4
  topic_fruit['x0-f2'] = 0.4
  topic_fruit['f0-x1'] = 0.2
  topic_fruit['f1-x1'] = 0.5
  topic_fruit['f2-x1'] = 0.3
  
  topic_tannin = CPD.new
  topic_tannin['x0-t0'] = 0.3
  topic_tannin['x0-t1'] = 0.4
  topic_tannin['x0-t2'] = 0.3
  topic_tannin['x1-t0'] = 0.6
  topic_tannin['x1-t1'] = 0.1
  topic_tannin['x1-t2'] = 0.3
  
  user_fruit = CPD.new
  user_fruit['u0-f0'] = 0.4
  user_fruit['u0-f1'] = 0.3
  user_fruit['u0-f2'] = 0.3
  user_fruit['u1-f0'] = 0.1
  user_fruit['u1-f1'] = 0.2
  user_fruit['u1-f2'] = 0.7
  
  user_tannin = CPD.new
  user_tannin[ 'u0-t0'] = 0.1 
  user_tannin[ 'u0-t1'] = 0.4
  user_tannin[ 'u0-t2'] = 0.5
  user_tannin[ 'u1-t0'] = 0.2
  user_tannin[ 'u1-t1'] = 0.6
  user_tannin[ 'u1-t2'] = 0.2
  
  wine_user_fruit = CPD.new
  wine_user_fruit['w0-u0-f0'] = 0.08
  wine_user_fruit['w0-u0-f0'] = 0.141
  wine_user_fruit['w0-u0-f0'] = 0.099
  
  wine_user_tannin = CPD.new
  wine_user_tannin['w0-u0-t0'] = 0.051
  wine_user_tannin['w0-u0-t1'] = 0.076
  wine_user_tannin['w0-u0-t2'] = 0.15



# to get probability that user likes wine: 
# 1) get_wine_feature_cpds (reduce wine_topic to specific wine; factor wine_topic, topic_feature; marginalize out topic) 
# 2) get_user_feature_cpds (same as 1 using user input CPDs)
# 3) for each feature, square each value of the wine_feature_cpd (this returns the "ideal" value indicating 100% match)
# 4) for each feature, factor user_feature and wine_feature (eg: returns wine_user_fruit example above)
# 5) for each feature, sum the values of the wine_user_feature CPD
# 6) divide result by the 'ideal match' value for the feature
# 7) average the match_by_feature across all features
# alternatively, to get match-breakdown by feature, stop at step6    
# 

    
  f = BayesMethods.factor wine_topic, topic_fruit
  puts f     
  #  m = BayesMethods.marginalize f, 'x'
  #  #puts m
  #  wine_fruit = BayesMethods.reduce_to m , 'w0'
  #  puts wine_fruit
  #  temp = BayesMethods.factor wine_topic, topic_tannin
  #  temp2 = BayesMethods.marginalize temp, 'x'
  #  wine_tannin = BayesMethods.reduce_to temp2, 'w0'
  #  puts
  #  puts wine_tannin
  #  puts
  #  user0_fruit = BayesMethods.reduce_to user_fruit, 'u0'
  #  user0_tannin = BayesMethods.reduce_to user_tannin, 'u0'
  #  puts user0_fruit
  #  puts
  #  puts user0_tannin
  # 
  #  #fruit_u0_w0 = BayesMethods.factor wine_fruit, user0_fruit
  #  tannin_u0_w0 = BayesMethods.factor wine_tannin, user0_tannin
  #  #puts fruit_u0_w0
  #  #puts
  #  puts tannin_u0_w0
   
end


main
