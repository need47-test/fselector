#
# FSelector: a Ruby gem for feature selection and ranking
#
module FSelector
#
# base algorithm for continuous feature
#
  class BaseContinuous < Base
    # include module
    include Normalizer
    
    # initialize from an existing data structure
    def initialize(data=nil)
      super(data)
    end
    

  end # class


end # module