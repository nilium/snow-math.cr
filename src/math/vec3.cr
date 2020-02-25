struct Snow::Vec3
  include VecN
  vector_common(Vec3, "xyz")

  # Return the cross product of the receiver and rhs.
  def cross(rhs : Vec3)
    self.class.new(
      @y * rhs.z - @z * rhs.y,
      @x * rhs.z - @z * rhs.x,
      @x * rhs.y - @y * rhs.x
    )
  end

  def cross!(rhs : Vec3)
    x = @y * rhs.z - @z * rhs.y
    y = @x * rhs.z - @z * rhs.x
    z = @x * rhs.y - @y * rhs.x
    @x = x
    @y = y
    @z = z
    self
  end

  # Cross product operator.
  @[AlwaysInline]
  def %(rhs : Vec3)
    cross(rhs)
  end

  # Alias for Mat3.transform(self).
  @[AlwaysInline]
  def *(rhs : Mat3)
    rhs.tranform(self)
  end

  @[AlwaysInline]
  def to_vec2
    self.xy
  end

  @[AlwaysInline]
  def to_vec3
    self
  end

  @[AlwaysInline]
  def to_vec4
    Vec4.new(@x, @y, @z, 1)
  end

  @[AlwaysInline]
  def to_vec4(last : Float64)
    Vec4.new(@x, @y, @z, last)
  end

  # Generate swizzle methods.
  include Swizzle
  swizzle_methods(Vec2,
    "xx", "xy", "xz", "yx", "yy", "yz", "zx", "zy", "zz",
  )
  swizzle_methods(self.class,
    "xxx", "xxy", "xxz", "xyx", "xyy", "xyz", "xzx", "xzy", "xzz", "yxx",
    "yxy", "yxz", "yyx", "yyy", "yyz", "yzx", "yzy", "yzz", "zxx", "zxy",
    "zxz", "zyx", "zyy", "zyz", "zzx", "zzy", "zzz",
  )
  swizzle_methods(Vec4,
    "xxxx", "xxxy", "xxxz", "xxyx", "xxyy", "xxyz", "xxzx", "xxzy", "xxzz",
    "xyxx", "xyxy", "xyxz", "xyyx", "xyyy", "xyyz", "xyzx", "xyzy", "xyzz",
    "xzxx", "xzxy", "xzxz", "xzyx", "xzyy", "xzyz", "xzzx", "xzzy", "xzzz",
    "yxxx", "yxxy", "yxxz", "yxyx", "yxyy", "yxyz", "yxzx", "yxzy", "yxzz",
    "yyxx", "yyxy", "yyxz", "yyyx", "yyyy", "yyyz", "yyzx", "yyzy", "yyzz",
    "yzxx", "yzxy", "yzxz", "yzyx", "yzyy", "yzyz", "yzzx", "yzzy", "yzzz",
    "zxxx", "zxxy", "zxxz", "zxyx", "zxyy", "zxyz", "zxzx", "zxzy", "zxzz",
    "zyxx", "zyxy", "zyxz", "zyyx", "zyyy", "zyyz", "zyzx", "zyzy", "zyzz",
    "zzxx", "zzxy", "zzxz", "zzyx", "zzyy", "zzyz", "zzzx", "zzzy", "zzzz",
  )
end
