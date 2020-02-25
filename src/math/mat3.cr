struct Snow::Mat3
  include MatN

  matrix_common "xyz", Vec3

  # Return a rotation matrix around the axis X, Y, and Z.
  @[AlwaysInline]
  def self.angle_axis(angle : Rotation, x : Float64, y : Float64, z : Float64)
    self.angle_axis(angle.to_rad.to_f, x, y, z)
  end

  # Return a rotation matrix around the axis vector.
  @[AlwaysInline]
  def self.angle_axis(angle : Rotation, axis : Vec3)
    self.angle_axis(angle.to_rad.to_f, axis.x, axis.y, axis.z)
  end

  # Return a rotation matrix around the axis vector.
  # If not using a Rotation, the angle is in Radians.
  @[AlwaysInline]
  def self.angle_axis(angle : Float64, axis : Vec3)
    self.angle_axis(angle, axis.x, axis.y, axis.z)
  end

  # Return a rotation matrix around the axis X, Y, and Z.
  # If not using a Rotation, the angle is in Radians.
  def self.angle_axis(angle : Float64, x : Float64, y : Float64, z : Float64)
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

      xy * ic + zs,
      yy + c * (1_f64 - yy),
      yz * ic - xs,

      xz * ic - ys,
      yz * ic + xs,
      zz + c * (1_f64 - zz)
    )
  end

  # def self.zero
  #   self.new(0, 0, 0, 0, 0, 0, 0, 0, 0)
  # end

  # def self.identity
  #   m = self.new
  #   m.xx = 1
  #   m.yy = 1
  #   m.zz = 1
  #   m
  # end

  # def copy(rhs : Mat3)
  #   to_unsafe.copy_from(rhs.to_unsafe, 9)
  #   self
  # end

  # def dup
  #   self.class.new(@elems)
  # end

  def rows : Array(Vec3)
    [
      row(0),
      row(1),
      row(2),
    ]
  end

  def row(index : Int) : Vec3
    case index
    when 0 then Vec3.new(xx, xy, xz)
    when 1 then Vec3.new(yx, yy, yz)
    when 2 then Vec3.new(zx, zy, zz)
    else
      raise IndexError.new
    end
  end

  def column(index : Int) : Vec3
    case index
    when 0 then Vec3.new(xx, yx, zx)
    when 1 then Vec3.new(yx, yy, zy)
    when 2 then Vec3.new(zx, yz, zz)
    else
      raise IndexError.new
    end
  end

  def transpose!
    {% for swap in {
                     {"xy", "yx"},
                     {"xz", "zx"},
                     {"yz", "zy"},
                   } %}
      t = self.{{swap[0].id}}
      self.{{swap[0].id}} = self.{{swap[1].id}}
      self.{{swap[1].id}} = t
    {% end %}
    self
  end

  def scale(rhs : Vec3)
    m = dup
    m.rx = m.rx * rhs
    m.ry = m.ry * rhs
    m.rz = m.rz * rhs
    m
  end

  def scale!(rhs : Vec3)
    self.rx = self.rx * rhs
    self.ry = self.ry * rhs
    self.rz = self.rz * rhs
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

  def multiply(rhs : Mat3)
    m = self
    m.multiply!(rhs)
  end

  def multiply!(rhs : Mat3)
    rrx = rhs.rx
    rry = rhs.ry
    rrz = rhs.rz

    cx = self.cx
    self.xx = cx.dot(rrx)
    self.xy = cx.dot(rry)
    self.xz = cx.dot(rrz)

    cy = self.cy
    self.yx = cy.dot(rrx)
    self.yy = cy.dot(rry)
    self.yz = cy.dot(rrz)

    cz = self.cz
    self.zx = cz.dot(rrx)
    self.zy = cz.dot(rry)
    self.zz = cz.dot(rrz)

    self
  end

  @[AlwaysInline]
  def *(rhs : Mat3)
    multiply(rhs)
  end

  def multiply(rhs : Vec4)
    Vec3.new(
      rhs.dot(self.cx),
      rhs.dot(self.cy),
      rhs.dot(self.cz),
      rhs.w
    )
  end

  def multiply(rhs : Vec3)
    Vec3.new(
      rhs.dot(self.cx),
      rhs.dot(self.cy),
      rhs.dot(self.cz),
    )
  end

  @[AlwaysInline]
  def *(rhs : Vec3)
    multiply(rhs)
  end

  def multiply(rhs : Vec2)
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
    m = self
    m.orthogonal!
    m
  end

  def orthogonal!
    c = self.cy
    c.cross!(self.cz.normal)
    c.normal!
    self.cx = t
    self.cy = self.cz.cross(c)
  end

  def cofactor
    cx = self.cx
    cy = self.cy
    cz = self.cz
    Mat3.new(
      cy.cross(cz),
      cx.cross(cz),
      cx.cross(cy)
    )
  end

  def cofactor!
    cx = self.cx
    cy = self.cy
    cz = self.cz
    self.cx = cy.cross(cz)
    self.cy = cx.cross(cz)
    self.cz = cx.cross(cy)
    self
  end

  def determinant
    c = self.cy.cross(self.cz)
    c.dot(self.cx)
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
    self
  end

  def to_mat4
    Mat4.new(
      self.rx,
      self.ry,
      self.rz
    )
  end
end
