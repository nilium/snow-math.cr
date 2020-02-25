module Snow
  DEG2RAD = Math::PI / 180_f64
  RAD2DEG = 180_f64 / Math.PI

  @[AlwaysInline]
  def self.deg2rad(x : Float64)
    x * DEG2RAD
  end

  @[AlwaysInline]
  def self.rad2deg(x : Float64)
    x * RAD2DEG
  end

  abstract struct Rotation
    def self.[](f : Float64)
      self.new(f)
    end

    def initialize(@f : Float64)
    end

    abstract def to_deg : Degrees
    abstract def to_rad : Radians

    forward_missing_to @f

    @[AlwaysInline]
    def to_f
      @f
    end
  end

  struct Radians < Rotation
    @[AlwaysInline]
    def to_deg : Degrees
      Radians.new(Snow.rad2deg(@f))
    end

    @[AlwaysInline]
    def to_rad : Radians
      self
    end
  end

  struct Degrees < Rotation
    @[AlwaysInline]
    def to_deg : Degrees
      self
    end

    @[AlwaysInline]
    def to_rad : Radians
      Radians.new(Snow.deg2rad(@f))
    end
  end
end
