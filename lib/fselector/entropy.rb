#
# entropy-related functions for discrete data
#
module Entropy
  #
  # get the marginal entropy of array (X)
  #
  #     H(X) = -1 * sigma_i (P(x_i) log2 P(x_i))
  #
  # @param [Array] arrX array of interest
  # @return [Float] H(X)
   def get_marginal_entropy(arrX)
    h = 0.0
    n = arrX.size.to_f

    arrX.uniq.each do |x_i|
      p = arrX.count(x_i)/n
      h += -1.0 * (p * Math.log2(p))
    end

    h
  end # get_marginal_entropy
  
  
  #
  # get the conditional entropy of array (X) given another array (Y)
  #
  #     H(X|Y) = sigma_j (P(y_j) * H(C|y_j))
  #     
  #     where H(X|y_j) = -1 * sigma_i (P(x_i|y_j) log2 P(x_i|y_j))
  #
  # @param [Array] arrX the first array
  # @param [Array] arrY the second array
  # @return [Float] H(X|Y)
  # @note arrX and arrY must be of same length
   def get_conditional_entropy(arrX, arrY)
    abort "[#{__FILE__}@#{__LINE__}]: "+
          "array must be of same length" if not arrX.size == arrY.size

    hxy = 0.0
    n = arrX.size.to_f

    arrY.uniq.each do |y_j|
      p1 = arrY.count(y_j)/n

      indices = (0...n).to_a.select { |k| arrY[k] == y_j }
      xvs = arrX.values_at(*indices)
      m = xvs.size.to_f

      xvs.uniq.each do |x_i|
        p2 = xvs.count(x_i)/m

        hxy += -1.0 * p1 * (p2 * Math.log2(p2))
      end
    end

    hxy
  end # get_conditional_entropy
  
  
  #
  # get the joint entropy of array (X) and array (Y)
  # 
  #     H(X,Y) = H(Y) + H(X|Y)
  #            = H(X) + H(Y|X)
  #     
  #     i.e. H(X,Y) == H(Y,X)
  #
  # @param [Array] arrX the first array
  # @param [Array] arrY the second array
  # @return [Float] H(X,Y)
  # @note arrX and arrY must be of same length
   def get_joint_entropy(arrX, arrY)
    abort "[#{__FILE__}@#{__LINE__}]: "+
        "array must be of same length" if not arrX.size == arrY.size

    get_marginal_entropy(arrY) + get_conditional_entropy(arrX, arrY)
  end # get_joint_entropy
  
  
  #
  # get the symmetrical uncertainty of array (X) and array (Y)
  #
  # @param [Array] arrX the first array
  # @param [Array] arrY the second array
  # @return [Float] SU(X,Y)
  #
  def get_symmetrical_uncertainty(arrX, arrY)
    abort "[#{__FILE__}@#{__LINE__}]: "+
        "array must be of same length" if not arrX.size == arrY.size
    
    hx = get_marginal_entropy(arrX)
    hxy = get_conditional_entropy(arrX, arrY)
    hy = get_marginal_entropy(arrY)
    
    su = 0.0
    su = 2*(hx-hxy)/(hx+hy) if not (hx+hy).zero?
  end
  
  
end # module


=begin

class Test
  include Entropy
end

labels = ['A', 'B', 'C']
arrX, arrY = [], []
#40.times { arrX << labels[rand(labels.size)] }
#40.times { arrY << labels[rand(labels.size)] }

data = {
  :c1 => [
    {:f1 => 1},{:f1 => 1},{:f1 => 1},{:f1 => 1},{:f1 => 1},
    {:f1 => 0}
  ],
  :c2 => [
    {:f1 => 1},
    {:f1 => 1},
    {:f1 => 1},
    {:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},
    {:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},
    {:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},
    {:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0},{:f1 => 0}
  ]
}

data.each do |c, ss|
  ss.each do |s|
    arrX << c
  arrY << s[:f1]
  end
end

puts arrX.join(',')
puts arrY.join(',')

t = Test.new
hx = t.get_marginal_entropy(arrX)
hy = t.get_marginal_entropy(arrY)
hxy = t.get_conditional_entropy(arrX, arrY)
hyx = t.get_conditional_entropy(arrY, arrX)
ig1 = hx-hxy
ig2 = hy-hyx
hx_y = t.get_joint_entropy(arrX, arrY)
hy_x = t.get_joint_entropy(arrY, arrX)

puts
puts [hx, hxy, hy, hyx, ig1, ig2, ig1-ig2 ].join(',')
puts [hx_y, hy_x, hx_y-hy_x].join(',')

=end
