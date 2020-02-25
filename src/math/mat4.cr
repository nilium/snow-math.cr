struct Snow::Mat4
  include MatN

  matrix_common "xyzw", Vec4

  # Return a rotation matrix around the axis X, Y, and Z.
  @[AlwaysInline]
  def self.euler_rotation(angle : Rotation, x : Float64, y : Float64, z : Float64)
    self.euler_rotation(angle.to_rad.to_f, x, y, z)
  end

  # Return a rotation matrix around the axis vector.
  @[AlwaysInline]
  def self.euler_rotation(angle : Rotation, axis : Vec3)
    self.euler_rotation(angle.to_rad.to_f, axis.x, axis.y, axis.z)
  end

  # Return a rotation matrix around the axis vector.
  # If not using a Rotation, the angle is in Radians.
  @[AlwaysInline]
  def self.euler_rotation(angle : Float64, axis : Vec3)
    self.euler_rotation(angle, axis.x, axis.y, axis.z)
  end

  # Return a rotation matrix around the axis X, Y, and Z.
  # If not using a Rotation, the angle is in Radians.
  def self.euler_rotation(angle : Float64, x : Float64, y : Float64, z : Float64)
    c = Math.cos(angle)
    s = Math.sin(angle)
    ic = 1_f64 - c
    xy = x * y * ic
    yz = y * z * ic
    xz = x * z * ic
    xs = s * x
    ys = s * y
    zs = s * z
    xx = x * x
    yy = y * y
    zz = z * z

    self.new(
      xx + c * (1_f64 - xx),
      xy * ic - zs,
      z * x * ic + ys,
      0,

      xy * ic + zs,
      yy + c * (1_f64 - yy),
      yz * ic - xs,
      0,

      xz * ic - ys,
      yz * ic + xs,
      zz + c * (1_f64 - zz),
      0,

      0, 0, 0, 1
    )
  end

  def self.translation(orig : Vec3)
    self.translation(orig.x, orig.y, orig.z)
  end

  def self.translation(x : Float64, y : Float64, z : Float64)
    t = self.identity
    t.wx = x
    t.wy = y
    t.wz = z
    t
  end

  # def self.zero
  #   self.new(
  #     0, 0, 0, 0,
  #     0, 0, 0, 0,
  #     0, 0, 0, 0,
  #     0, 0, 0, 0
  #   )
  # end

  # def self.identity
  #   m = self.new
  #   m.xx = 1
  #   m.yy = 1
  #   m.zz = 1
  #   m.ww = 1
  #   m
  # end

  # def zero!
  #   @elems.map! { 0 }
  # end

  def zero?
    @elems.all? { |it| Snow.zero?(0) }
  end

  # def identity!
  #   @elems.map! { 0 }
  #   self.xx = 1
  #   self.yy = 1
  #   self.zz = 1
  #   self.ww = 1
  #   self
  # end

  # def copy(rhs : Mat4)
  #   to_unsafe.copy_from(rhs.to_unsafe, 16)
  #   self
  # end

  # def dup
  #   t = self
  #   t
  # end

  def rows : Array(Vec4)
    [
      row(0),
      row(1),
      row(2),
      row(3),
    ]
  end

  def row(index : Int) : Vec4
    case index
    when 0 then Vec4.new(xx, xy, xz, xw)
    when 1 then Vec4.new(yx, yy, yz, yw)
    when 2 then Vec4.new(zx, zy, zz, zw)
    when 3 then Vec4.new(wx, wy, wz, ww)
    else
      raise IndexError.new
    end
  end

  def column(index : Int) : Vec3
    case index
    when 0 then Vec4.new(xx, yx, zx, wx)
    when 1 then Vec4.new(xy, yy, zy, wy)
    when 2 then Vec4.new(xz, yz, zz, wz)
    when 3 then Vec4.new(xw, yw, zw, ww)
    else
      raise IndexError.new
    end
  end

  def transpose!
    {% for swap in {
                     {"xy", "yx"},
                     {"xz", "zx"},
                     {"xw", "wx"},
                     {"yz", "zy"},
                     {"yw", "wy"},
                     {"zw", "wz"},
                   } %}
      t = self.{{swap[0].id}}
      self.{{swap[0].id}} = self.{{swap[1].id}}
      self.{{swap[1].id}} = t
    {% end %}
    self
  end

  def scale(rhs : Vec3)
    m = dup
    m.rx = m.rx.xyz * rhs
    m.ry = m.ry.xyz * rhs
    m.rz = m.rz.xyz * rhs
    m.rw = m.rw.xyz * rhs
    m
  end

  def scale!(rhs : Vec4)
    self.rx = self.rx * rhs
    self.ry = self.ry * rhs
    self.rz = self.rz * rhs
    self.rw = self.rw * rhs
    self
  end

  def scale(rhs : Vec4)
    m = dup
    m.rx = m.rx * rhs
    m.ry = m.ry * rhs
    m.rz = m.rz * rhs
    m.rw = m.rw * rhs
    m
  end

  def scale!(rhs : Vec4)
    self.rx = self.rx * rhs
    self.ry = self.ry * rhs
    self.rz = self.rz * rhs
    self.rw = self.rw * rhs
    self
  end

  def scale(rhs : Float64)
    m = dup
    m.scale! rhs
    m
  end

  def scale!(rhs : Float64)
    @elems.map! { |it| it * rhs }
    self
  end

  @[AlwaysInline]
  def translate(x : Float64, y : Float64, z : Float64)
    translate(Vec3.new(x, y, z))
  end

  def translate(rhs : Vec3)
    t = self
    rhs = self.rotate(rhs)
    t.wx = t.wx + rhs.x
    t.wy = t.wy + rhs.y
    t.wz = t.wz + rhs.z
    t
  end

  @[AlwaysInline]
  def translate!(x : Float64, y : Float64, z : Float64)
    translate(Vec3.new(x, y, z))
  end

  def translate!(rhs : Vec3)
    rhs = self.rotate(rhs)
    self.wx += rhs.x
    self.wy += rhs.y
    self.wz += rhs.z
    self
  end

  def multiply(rhs : Mat4)
    cx = self.cx
    cy = self.cy
    cz = self.cz
    cw = self.cw

    rx = self.cx
    ry = self.cy
    rz = self.cz
    rw = self.cw

    rcx = rhs.cx
    rcy = rhs.cy
    rcz = rhs.cz
    rcw = rhs.cw

    t = self

    t.xx = rx.dot(rcx)
    t.yx = rx.dot(rcy)
    t.zx = rx.dot(rcz)
    t.wx = rx.dot(rcw)

    t.xy = ry.dot(rcx)
    t.yy = ry.dot(rcy)
    t.zy = ry.dot(rcz)
    t.wy = ry.dot(rcw)

    t.xz = rz.dot(rcx)
    t.yz = rz.dot(rcy)
    t.zz = rz.dot(rcz)
    t.wz = rz.dot(rcw)

    t.xw = rw.dot(rcx)
    t.yw = rw.dot(rcy)
    t.zw = rw.dot(rcz)
    t.ww = rw.dot(rcw)

    t
  end

  def multiply!(rhs : Mat4)
    cx = self.cx
    cy = self.cy
    cz = self.cz
    cw = self.cw

    rx = self.cx
    ry = self.cy
    rz = self.cz
    rw = self.cw

    rcx = rhs.cx
    rcy = rhs.cy
    rcz = rhs.cz
    rcw = rhs.cw

    self.xx = rx.dot(rcx)
    self.yx = rx.dot(rcy)
    self.zx = rx.dot(rcz)
    self.wx = rx.dot(rcw)

    self.xy = ry.dot(rcx)
    self.yy = ry.dot(rcy)
    self.zy = ry.dot(rcz)
    self.wy = ry.dot(rcw)

    self.xz = rz.dot(rcx)
    self.yz = rz.dot(rcy)
    self.zz = rz.dot(rcz)
    self.wz = rz.dot(rcw)

    self.xw = rw.dot(rcx)
    self.yw = rw.dot(rcy)
    self.zw = rw.dot(rcz)
    self.ww = rw.dot(rcw)

    self
  end

  @[AlwaysInline]
  def *(rhs : Mat4)
    multiply(rhs)
  end

  def multiply(rhs : Vec4)
    Vec4.new(
      rhs.dot(self.cx),
      rhs.dot(self.cy),
      rhs.dot(self.cz),
      rhs.dot(self.cw)
    )
  end

  @[AlwaysInline]
  def rotate(rhs : Vec4)
    rhs.w = 0
    multiply(rhs)
  end

  def multiply(rhs : Vec3)
    multiply(rhs.to_vec4).to_vec3
  end

  def rotate(rhs : Vec3)
    multiply(rhs.to_vec4(0)).to_vec3
  end

  @[AlwaysInline]
  def *(rhs : Vec3)
    multiply(rhs)
  end

  def multiply(rhs : Vec2)
    Vec2.new(
      rhs.dot(self.cx.xy) + self.wx,
      rhs.dot(self.cy.xy) + self.wy
    )
  end

  def rotate(rhs : Vec2)
    Vec2.new(
      rhs.dot(self.rx.xy),
      rhs.dot(self.ry.xy)
    )
  end

  @[AlwaysInline]
  def *(rhs : Vec2)
    multiply(rhs)
  end

  def orthogonal
    t = self
    t.orthogonal!
    t
  end

  def orthogonal!
    t = self.ry
    t.cross!(self.rz.normal)
    t.normal!
    self.rx = t
    self.ry = self.rz.cross(t)
  end

  @[AlwaysInline]
  private def cofactor(r0, r1, r2, c0, c1, c2)
    p = @elems.to_unsafe
    (p[r0*4 + c0] * ((p[r1*4 + c1] * p[r2*4 + c2]) - (p[r2*4 + c1] * p[r1*4 + c2]))) -
      (p[r0*4 + c1] * ((p[r1*4 + c0] * p[r2*4 + c2]) - (p[r2*4 + c0] * p[r1*4 + c2]))) +
      (p[r0*4 + c2] * ((p[r1*4 + c0] * p[r2*4 + c1]) - (p[r2*4 + c0] * p[r1*4 + c1])))
  end

  def adjoint
    self.class.new(
      self.cofactor(1, 2, 3, 1, 2, 3),
      -self.cofactor(0, 2, 3, 1, 2, 3),
      self.cofactor(0, 1, 3, 1, 2, 3),
      -self.cofactor(0, 1, 2, 1, 2, 3),

      -self.cofactor(1, 2, 3, 0, 2, 3),
      self.cofactor(0, 2, 3, 0, 2, 3),
      -self.cofactor(0, 1, 3, 0, 2, 3),
      self.cofactor(0, 1, 2, 0, 2, 3),

      self.cofactor(1, 2, 3, 0, 1, 3),
      -self.cofactor(0, 2, 3, 0, 1, 3),
      self.cofactor(0, 1, 3, 0, 1, 3),
      -self.cofactor(0, 1, 2, 0, 1, 3),

      -self.cofactor(1, 2, 3, 0, 1, 2),
      self.cofactor(0, 2, 3, 0, 1, 2),
      -self.cofactor(0, 1, 3, 0, 1, 2),
      self.cofactor(0, 1, 2, 0, 1, 2)
    )
  end

  def adjoint!
    t = self
    self.xx = t.cofactor(1, 2, 3, 1, 2, 3)
    self.yx = -t.cofactor(0, 2, 3, 1, 2, 3)
    self.zx = t.cofactor(0, 1, 3, 1, 2, 3)
    self.wx = -t.cofactor(0, 1, 2, 1, 2, 3)

    self.xy = -t.cofactor(1, 2, 3, 0, 2, 3)
    self.yy = t.cofactor(0, 2, 3, 0, 2, 3)
    self.zy = -t.cofactor(0, 1, 3, 0, 2, 3)
    self.wy = t.cofactor(0, 1, 2, 0, 2, 3)

    self.xz = t.cofactor(1, 2, 3, 0, 1, 3)
    self.yz = -t.cofactor(0, 2, 3, 0, 1, 3)
    self.zz = t.cofactor(0, 1, 3, 0, 1, 3)
    self.wz = -t.cofactor(0, 1, 2, 0, 1, 3)

    self.xw = -t.cofactor(1, 2, 3, 0, 1, 2)
    self.yw = t.cofactor(0, 2, 3, 0, 1, 2)
    self.zw = -t.cofactor(0, 1, 3, 0, 1, 2)
    self.ww = t.cofactor(0, 1, 2, 0, 1, 2)
    self
  end

  def determinant
    (self.xx * self.cofactor(1, 2, 3, 1, 2, 3)) -
      (self.xy * self.cofactor(1, 2, 3, 0, 2, 3)) +
      (self.xz * self.cofactor(1, 2, 3, 0, 1, 3)) -
      (self.xw * self.cofactor(1, 2, 3, 0, 1, 2))
  end

  def adjoint
    c = self.cofactor
    c.transpose!
    c
  end

  def adjoint!
    cofactor!
    transpose!
    self
  end

  def inverse
    d = self.determinant
    return self.class.zero if d == 0
    d = 1.0 / d
    m = self.adjoint
    m.scale! d
    m
  end

  def inverse!
    d = self.determinant
    if d == 0
      self.zero!
      return self
    end
    d = 1.0 / d
    self.adjoint!
    self.scale! d
    self
  end

  def to_mat3
    Mat3.new(
      self.rx.xyz,
      self.ry.xyz,
      self.rz.xyz
    )
  end

  def to_mat4
    self
  end
end
