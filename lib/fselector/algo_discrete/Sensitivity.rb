#
# FSelector: a Ruby gem for feature selection and ranking
#
module FSelector
#
# Sensitivity (SN)
#
#             TP        A
#     SN = ------- = -----
#            TP+FN     A+C
#  
# ref: [Wikipedia](http://en.wikipedia.org/wiki/Sensitivity_and_specificity)
#
  class Sensitivity < BaseDiscrete
    # this algo outputs weight for each feature
    @algo_type = :feature_weighting
    
    private
    
    # calculate contribution of each feature (f) for each class (k)
    def calc_contribution(f)
      each_class do |k|
        a, c = get_A(f, k), get_C(f, k)
        
        s =0.0
        x = a+c
        
        s = a/x if not x.zero?
        
        set_feature_score(f, k, s)
      end
    end # calc_contribution
    
    
  end # class
  
  
  
  # shortcut so that you can use FSelector::SN instead of FSelector::Sensitivity
  SN = Sensitivity
  # Sensitivity, also known as Recall
  Recall = Sensitivity
  
  
end # module
