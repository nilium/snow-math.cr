module Snow::MatN
  macro matrix_common(components, vec)
    {% coms = components.chars.map { |c| c.id } %}

    {% for c in coms %}
      property {{c}} : {{vec}}
    {% end %}

    def self.[](
      {% for c in coms %}
        {{c}} : {{vec}},
      {% end %}
    )
      self.new(
      {% for c in coms %}
        {{c}},
      {% end %}
      )
    end

    def initialize(
      {% for c in coms %}
      {% for r in coms %} {{r}}{{c}} : Float64,{% end %}
      {% end %}
    )
      self.new(
        {% for c in coms %}
        {% for r in coms %} {{r}}{{c}},{% end %}
        {% end %}
      )
    end

    def initialize()
      {% for c in coms %}
        @{{c}} = {{vec}}.zero
      {% end %}
    end

    def initialize(
      {% for c in coms %}
        @{{c}} : {{vec}},
      {% end %}
    )
    end

    def initialize(
      {% for c in coms %}
      {% for r in coms %} {{r}}{{c}} : Float64,{% end %}
      {% end %}
    )
      {% for c in coms %}
        @{{c}} = {{vec}}.new({{ coms.map { |r| "#{c}#{r}" }.join(", ").id }})
      {% end %}
    end

    @[AlwaysInline]
    def self.zero
      self.new
    end

    @[AlwaysInline]
    def self.identity
      self.new(
        {% for c in coms %}
          {{vec}}.new({{ coms.map { |it| (it == c) ? 1 : 0 }.join(", ").id }}),
        {% end %}
      )
    end

    @[AlwaysInline]
    def dup
      t = self
      t
    end

    def zero!
      {% for c in coms %}
        @{{c}} = {{vec}}.zero
      {% end %}
    end

    @[AlwaysInline]
    def transpose
      dup.transpose!
    end

    def equiv?(rhs : self)
      {{ coms.map { |c| "@#{c} == rhs.#{c}" }.join(" && ").id }}
    end

    @[AlwaysInline]
    def ==(rhs : self)
      self.equiv?(rhs)
    end

    @[AlwaysInline]
    def !=(rhs : self)
      !self.equiv?(rhs)
    end

    {% for c, ci in coms %}
      @[AlwaysInline]
      def c{{c}}
        @{{c}}
      end

      @[AlwaysInline]
      def c{{c}}=(col : {{vec}})
        @{{c}} = col
      end

      @[AlwaysInline]
      def r{{c}}
        {{ vec }}.new(
        {% for r in coms %}
          @{{r}}.{{c}},
        {% end %}
        )
      end

      @[AlwaysInline]
      def r{{c}}=(row : {{vec}})
        {% for r in coms %}
        self.{{r}}.{{c}} = row.{{r}}
        {% end %}
        row
      end

      {% for r in coms %}
        @[AlwaysInline]
        def {{c}}{{r}}
          @{{c}}.{{r}}
        end

        @[AlwaysInline]
        def {{c}}{{r}}=(f : Float64)
          @{{c}}.{{r}} = f
        end
      {% end %}
    {% end %}
  end
end
