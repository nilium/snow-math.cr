module Snow::VecN
  # vector_common declares common constructors and methods for vectors.
  #
  # This cannot be safely used with a quaternion, for example, since
  # quaternions do not share the same set of methods as vectors.
  macro vector_common(klass, components)
    {% coms = components.chars.map { |it| it.id } %}
    {% for c in coms %}
    property {{c}} : Float64
    {% end %}

    def initialize
      {% for c, i in coms %}
      @{{c}} = 0_f64
      {% end %}
    end

    # Create a new {{ klass.id }} from the given arguments.
    def initialize(@{{ components.chars.join(" : Float64, @").id }} : Float64)
    end

    # Create a new {{ klass.id }} the given arguments.
    # All arguments are converted to Float64s.
    def initialize({{ components.chars.join(" : Number, ").id }} : Number)
      {% for c in coms %}
      @{{c}} = {{c}}.to_f64
      {% end %}
    end

    # Create a new {{ klass.id }} from an array of Float64s.
    def initialize(a : Indexable(Float64))
      raise ArgumentError.new("array must have at least {{coms.size}} items") if a.size < {{coms.size}}
      {% for c, i in coms %}
      @{{c}} = a[{{i}}]
      {% end %}
    end

    # Create a new {{ klass.id }} from an array of numbers.
    def initialize(a : Indexable(Number))
      raise ArgumentError.new("array must have at least {{coms.size}} items") if a.size < {{coms.size}}
      {% for c, i in coms %}
      @{{c}} = a[{{i}}].to_f64
      {% end %}
    end

    # Alias for new({{ coms.map { |it| "Float64" }.join(", ").id }}).
    def self.[]({{ components.chars.join(" : Float64, ").id }} : Float64)
      self.new({{ components.chars.join(", ").id }})
    end

    # Alias for new({{ coms.map { |it| "Number" }.join(", ").id }}).
    def self.[]({{ components.chars.join(" : Number, ").id }} : Number)
      self.new({{ components.chars.join(".to_f64, ").id }}.to_f64)
    end

    # Alias for new(Array(Float64)).
    def self.[](a : Indexable(Float64))
      self.new(a)
    end

    # Alias for new(Indexable(Number)).
    def self.[](a : Indexable(Number))
      self.new(a)
    end

    # Create a new {{ klass.id }} with all components set to 0.
    @[AlwaysInline]
    def self.zero
      self.new
    end

    # Create a new {{ klass.id }} with all components set to 1.
    @[AlwaysInline]
    def self.one
      self.new({{ coms.map { |it| 1 }.join(", ").id }})
    end

    # Copy rhs's components into the receiver.
    def copy(rhs : self)
      {% for c in coms %}
      @{{c}} = rhs.{{c}}
      {% end %}
      self
    end

    def [](index : Int)
      case index
      {% for c, i in coms %}
      when {{i}}, {{-coms.size + i}} then @{{c}}
      {% end %}
      else
        raise IndexError.new
      end
    end

    def []=(index : Int, f : Float64)
      case index
      {% for c, i in coms %}
      when {{i}}, {{-coms.size + i}} then @{{c}} = f
      {% end %}
      else
        raise IndexError.new
      end
      f
    end

    def []=(index : Int, n : Number)
      self[index] = n.to_f64
    end

    # Make a copy of the receiver and return it.
    @[AlwaysInline]
    def dup
      t = self
      t
    end

    # Make a copy of the receiver and return it.
    @[AlwaysInline]
    def clone
      dup
    end

    # Return an array containing the receiver's components.
    def to_a : Array(Float64)
      [@{{ components.chars.join(", @").id }}]
    end

    # Zero out the receiver.
    def zero!
      {% for c in coms %}
      @{{c}} = 0
      {% end %}
      self
    end

    # Return a sum of the receiver's components.
    @[AlwaysInline]
    def sum
      @{{ components.chars.join("+ @").id }}
    end

    # Return the squared length of the receiver (the dot product of itself).
    @[AlwaysInline]
    def length_squared
      dot(self)
    end

    # Return the length, or magnitude, of the receiver.
    def length
      ::Math.sqrt(length_squared)
    end

    # Return the dot product of the receiver and rhs.
    @[AlwaysInline]
    def dot(rhs : self)
      {{ coms.map { |it| "@#{it} * rhs.#{it}" }.join(" + ").id }}
    end

    # Dot product operator.
    @[AlwaysInline]
    def &*(rhs : self)
      dot(rhs)
    end

    # Return the receiver as a normalized {{ klass.id }}.
    def normalize
      mag = length_squared
      return dup if Snow.equiv?(mag, 1)
      return self.class.zero if mag == 0
      mag = 1_f64 / ::Math.sqrt(mag)
      scale(mag)
    end

    # Normalize the receiver.
    def normalize!
      mag = length_squared
      return self if Snow.equiv?(mag, 1)
      return zero! if mag == 0
      mag = 1_f64 / ::Math.sqrt(mag)
      scale!(mag)
    end

    # Return the receiver, negated.
    def negate
      self.class.new({{ coms.map { |it| "-@#{it}" }.join(", ").id }})
    end

    # Negate the receiver.
    def negate!
      {% for c in coms %}
      @{{c}} = -@{{c}}
      {% end %}
      self
    end

    # Negate operator.
    @[AlwaysInline]
    def -
      negate
    end

    # Return the difference of the receiver and rhs.
    def subtract(rhs : self)
      self.class.new({{ coms.map { |it| "@#{it} - rhs.#{it}" }.join(", ").id }})
    end

    # Subtract rhs from the receiver.
    def subtract!(rhs : self)
      {% for c in coms %}
      @{{c}} -= rhs.{{c}}
      {% end %}
      self
    end

    # Subtract operator.
    @[AlwaysInline]
    def -(rhs : self)
      subtract(rhs)
    end

    # Return the sum of the receiver and rhs.
    def add(rhs : self)
      self.class.new({{ coms.map { |it| "@#{it} + rhs.#{it}" }.join(", ").id }})
    end

    # Add rhs to the receiver.
    def add!(rhs : self)
      {% for c in coms %}
      @{{c}} += rhs.{{c}}
      {% end %}
      self
    end

    # Add operator.
    @[AlwaysInline]
    def +(rhs : self)
      add(rhs)
    end

    # Return the quotient from dividing the receiver and rhs.
    def divide(rhs : self)
      self.class.new({{ coms.map { |it| "@#{it} / rhs.#{it}" }.join(", ").id }})
    end

    # Divide the receiver by rhs.
    def divide!(rhs : self)
      {% for c in coms %}
      @{{c}} /= rhs.{{c}}
      {% end %}
      self
    end

    # Divide operator.
    @[AlwaysInline]
    def /(rhs : self)
      divide(rhs)
    end

    # Return the product of the receiver and rhs.
    def multiply(rhs : self)
      self.class.new({{ coms.map { |it| "@#{it} * rhs.#{it}" }.join(", ").id }})
    end

    # Multiply the receiver by rhs.
    def multiply!(rhs : self)
      {% for c in coms %}
      @{{c}} *= rhs.{{c}}
      {% end %}
      self
    end

    # Multiply operator.
    @[AlwaysInline]
    def *(rhs : self)
      multiply(rhs)
    end

    # Return the receiver scaled by rhs.
    def scale(rhs : Float64)
      self.class.new({{ coms.map { |it| "@#{it} * rhs" }.join(", ").id }})
    end

    # Return the receiver scaled by rhs.
    def scale(rhs : Number)
      scale(rhs.to_f64)
    end

    # Scale the receiver by rhs.
    def scale!(rhs : Float64)
      {% for c in coms %}
      @{{c}} *= rhs
      {% end %}
      self
    end

    # Scale the receiver by rhs.
    def scale!(rhs : Number)
      scale!(rhs.to_f64)
    end

    # Scale operator.
    @[AlwaysInline]
    def *(mag : Float64)
      scale(mag)
    end

    # Scale operator.
    @[AlwaysInline]
    def *(mag : Number)
      scale(mag.to_f64)
    end

    # Return an inverse of the receiver.
    # If any component of the receiver is zero, the result is a zero vector.
    def inverse
      return self.class.zero if @x * @y == 0
      self.class.new({{ coms.map { |it| "1_f64 / @#{it}" }.join(", ").id }})
    end

    # Set the receiver to its inverse.
    # If any component of the receiver is zero, the receiver's components are
    # all zero.
    def inverse!
      return zero if @x * @y == 0
      {% for c in coms %}
      @{{c}} = 1_f64 / @{{c}}
      {% end %}
      self
    end

    # Inverse operator.
    @[AlwaysInline]
    def ~
      inverse
    end

    def reflect(rhs : self)
      rhs = rhs.normal
      subtract(rhs.scale(2 * self.dot(rhs)))
    end

    def project(rhs : self)
      rhs = rhs.normal
      rhs.scale!(self.dot(rhs))
    end

    def equiv?(rhs : self)
      {{ coms.map { |it| "Snow.equiv?(@#{it}, rhs.#{it})".id }.join(" && ").id }}
    end

    def ==(rhs : self)
      equiv?(rhs)
    end

    def !=(rhs : self)
      !equiv?(rhs)
    end

    def to_s(io : IO)
      io << '<' << {{ coms.join(" << ' ' << ").id }} << '>'
    end

    def to_s
      "<{{ coms.map { |it| "\#{@#{it}}".id }.join(" ").id }}>"
    end
  end
end
