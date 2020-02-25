module Snow
  MATH_VERSION = "0.1.0"

  # The accepted epsilon for two floating point values to be equivalent.
  EPSILON = 1.0e-12_f64

  @[AlwaysInline]
  def self.equiv?(x : Float64, y : Float64)
    zero?(x - y)
  end

  @[AlwaysInline]
  def self.zero?(x : Float64)
    x == 0 || x.abs <= EPSILON
  end
end
