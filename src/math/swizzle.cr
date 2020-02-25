module Snow::Swizzle
  # swizzle_methods generates swizzle methods matching xyzw components and
  # return the given klass.
  macro swizzle_methods(klass, *methods)
    {% for m in methods %}
    # Return a new {{klass.id}} containing the receiver's {{m.upcase.id}}
    # components (in that order).
    @[AlwaysInline]
    def {{m.id}}
      {{klass.id}}.new(@{{ m.chars.join(", @").id }})
    end
    {% end %}
  end
end
