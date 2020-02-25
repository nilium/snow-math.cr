struct Snow::Vec4
  include VecN
  vector_common(Vec4, "xyzw")

  # Alias for Mat3.transform(self).
  def *(rhs : Mat3)
    rhs.tranform(self)
  end

  @[AlwaysInline]
  def to_vec2
    self.xy
  end

  @[AlwaysInline]
  def to_vec3
    self.xyz
  end

  @[AlwaysInline]
  def to_vec4
    self.dup
  end

  @[AlwaysInline]
  def to_vec4(last : Float64)
    t = self
    self.w = last
    t
  end

  # Generate swizzle methods.
  include Swizzle
  swizzle_methods(Vec2,
    "ww", "wx", "wy", "wz", "xw", "xx", "xy", "xz", "yw", "yx", "yy", "yz",
    "zw", "zx", "zy", "zz",
  )
  swizzle_methods(Vec3,
    "www", "wwx", "wwy", "wwz", "wxw", "wxx", "wxy", "wxz", "wyw", "wyx",
    "wyy", "wyz", "wzw", "wzx", "wzy", "wzz", "xww", "xwx", "xwy", "xwz",
    "xxw", "xxx", "xxy", "xxz", "xyw", "xyx", "xyy", "xyz", "xzw", "xzx",
    "xzy", "xzz", "yww", "ywx", "ywy", "ywz", "yxw", "yxx", "yxy", "yxz",
    "yyw", "yyx", "yyy", "yyz", "yzw", "yzx", "yzy", "yzz", "zww", "zwx",
    "zwy", "zwz", "zxw", "zxx", "zxy", "zxz", "zyw", "zyx", "zyy", "zyz",
    "zzw", "zzx", "zzy", "zzz",
  )
  swizzle_methods(self.class,
    "wwww", "wwwx", "wwwy", "wwwz", "wwxw", "wwxx", "wwxy", "wwxz", "wwyw",
    "wwyx", "wwyy", "wwyz", "wwzw", "wwzx", "wwzy", "wwzz", "wxww", "wxwx",
    "wxwy", "wxwz", "wxxw", "wxxx", "wxxy", "wxxz", "wxyw", "wxyx", "wxyy",
    "wxyz", "wxzw", "wxzx", "wxzy", "wxzz", "wyww", "wywx", "wywy", "wywz",
    "wyxw", "wyxx", "wyxy", "wyxz", "wyyw", "wyyx", "wyyy", "wyyz", "wyzw",
    "wyzx", "wyzy", "wyzz", "wzww", "wzwx", "wzwy", "wzwz", "wzxw", "wzxx",
    "wzxy", "wzxz", "wzyw", "wzyx", "wzyy", "wzyz", "wzzw", "wzzx", "wzzy",
    "wzzz", "xwww", "xwwx", "xwwy", "xwwz", "xwxw", "xwxx", "xwxy", "xwxz",
    "xwyw", "xwyx", "xwyy", "xwyz", "xwzw", "xwzx", "xwzy", "xwzz", "xxww",
    "xxwx", "xxwy", "xxwz", "xxxw", "xxxx", "xxxy", "xxxz", "xxyw", "xxyx",
    "xxyy", "xxyz", "xxzw", "xxzx", "xxzy", "xxzz", "xyww", "xywx", "xywy",
    "xywz", "xyxw", "xyxx", "xyxy", "xyxz", "xyyw", "xyyx", "xyyy", "xyyz",
    "xyzw", "xyzx", "xyzy", "xyzz", "xzww", "xzwx", "xzwy", "xzwz", "xzxw",
    "xzxx", "xzxy", "xzxz", "xzyw", "xzyx", "xzyy", "xzyz", "xzzw", "xzzx",
    "xzzy", "xzzz", "ywww", "ywwx", "ywwy", "ywwz", "ywxw", "ywxx", "ywxy",
    "ywxz", "ywyw", "ywyx", "ywyy", "ywyz", "ywzw", "ywzx", "ywzy", "ywzz",
    "yxww", "yxwx", "yxwy", "yxwz", "yxxw", "yxxx", "yxxy", "yxxz", "yxyw",
    "yxyx", "yxyy", "yxyz", "yxzw", "yxzx", "yxzy", "yxzz", "yyww", "yywx",
    "yywy", "yywz", "yyxw", "yyxx", "yyxy", "yyxz", "yyyw", "yyyx", "yyyy",
    "yyyz", "yyzw", "yyzx", "yyzy", "yyzz", "yzww", "yzwx", "yzwy", "yzwz",
    "yzxw", "yzxx", "yzxy", "yzxz", "yzyw", "yzyx", "yzyy", "yzyz", "yzzw",
    "yzzx", "yzzy", "yzzz", "zwww", "zwwx", "zwwy", "zwwz", "zwxw", "zwxx",
    "zwxy", "zwxz", "zwyw", "zwyx", "zwyy", "zwyz", "zwzw", "zwzx", "zwzy",
    "zwzz", "zxww", "zxwx", "zxwy", "zxwz", "zxxw", "zxxx", "zxxy", "zxxz",
    "zxyw", "zxyx", "zxyy", "zxyz", "zxzw", "zxzx", "zxzy", "zxzz", "zyww",
    "zywx", "zywy", "zywz", "zyxw", "zyxx", "zyxy", "zyxz", "zyyw", "zyyx",
    "zyyy", "zyyz", "zyzw", "zyzx", "zyzy", "zyzz", "zzww", "zzwx", "zzwy",
    "zzwz", "zzxw", "zzxx", "zzxy", "zzxz", "zzyw", "zzyx", "zzyy", "zzyz",
    "zzzw", "zzzx", "zzzy", "zzzz",
  )
end
