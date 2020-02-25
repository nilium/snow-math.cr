struct Snow::Vec2
  include VecN
  vector_common(Vec2, "xy")

  # Alias for Mat3.transform(self).
  def *(rhs : Mat3)
    rhs.tranform(self)
  end

  @[AlwaysInline]
  def to_vec2
    self
  end

  @[AlwaysInline]
  def to_vec3
    Vec3.new(@x, @y)
  end

  @[AlwaysInline]
  def to_vec4
    Vec4.new(@x, @y, 0, 1)
  end

  @[AlwaysInline]
  def to_vec4(last : Float64)
    Vec4.new(@x, @y, 0, last)
  end

  # Generate swizzle methods.
  include Swizzle
  swizzle_methods(self.class,
    "xx", "xy", "yx", "yy",
  )
  swizzle_methods(Vec3,
    "xxx", "xxy", "xyx", "xyy", "yxx", "yxy", "yyx", "yyy",
  )
  swizzle_methods(Vec4,
    "xxxx", "xxxy", "xxyx", "xxyy", "xyxx", "xyxy", "xyyx", "xyyy", "yxxx",
    "yxxy", "yxyx", "yxyy", "yyxx", "yyxy", "yyyx", "yyyy",
  )
end
