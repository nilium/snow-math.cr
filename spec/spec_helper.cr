require "spec"
require "../src/snow-math"

def equiv(want : Number)
  be_close(want.to_f64, Snow::EPSILON)
end
