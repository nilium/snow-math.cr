require "./spec_helper"

module Snow
  describe Vec2 do
    describe "#initialize" do
      it "must accept two Float64s" do
        v = Vec2.new(1_f64, 2_f64)
        v.x.should eq 1_f64
        v.y.should eq 2_f64
      end

      it "must accept two of any Number" do
        v = Vec2.new(16_u8, 640_i16)
        v.x.should eq 16_f64
        v.y.should eq 640_f64
      end

      it "must accept an array of two or more Float64s" do
        v = Vec2.new([1_f64, 2_f64, 3_f64])
        v.x.should eq 1_f64
        v.y.should eq 2_f64
      end

      it "must accept an array of two or more Numbers" do
        v = Vec2.new([1_u8, 2_f64, 3_i32])
        v.x.should eq 1_f64
        v.y.should eq 2_f64
      end

      it "must not accept an array with less than two elements" do
        expect_raises(ArgumentError) { Vec2.new([] of Int64) }
        expect_raises(ArgumentError) { Vec2.new([] of Float64) }
        expect_raises(ArgumentError) { Vec2.new([1_i64]) }
        expect_raises(ArgumentError) { Vec2.new([1_f64]) }
      end
    end

    describe "#[]" do
      v = Vec2.new(1, 2)

      it "should return the first component for [0]" do
        v[0].should eq 1_f64
        v[-2].should eq 1_f64
      end

      it "should return the second component for [1]" do
        v[1].should eq 2_f64
        v[-1].should eq 2_f64
      end

      it "should raise an IndexError for other indices" do
        expect_raises(IndexError) { v[-3] }
        expect_raises(IndexError) { v[2] }
        expect_raises(IndexError) { v[3] }
        expect_raises(IndexError) { v[128] }
      end
    end

    describe "#[]=" do
      v = Vec2.new(1, 2)

      it "assigns the first component for [0] and [-2]" do
        v[-2] = 128
        v[0].should eq 128_f64
        v[0] = 256
        v[-2].should eq 256_f64
      end

      it "assigns the second component for [1] and [-1]" do
        v[-1] = 128
        v[1].should eq 128_f64
        v[1] = 256
        v[-1].should eq 256_f64
      end

      it "should raise an IndexError for other indices" do
        expect_raises(IndexError) { v[-3] = 0 }
        expect_raises(IndexError) { v[2] = 0 }
        expect_raises(IndexError) { v[3] = 0 }
        expect_raises(IndexError) { v[128] = 0 }
      end
    end

    describe "#length_squared" do
      it "reports a zero vector as zero" do
        Vec2.zero.length_squared.should eq 0
      end

      {
         1_f64 => 2_f64,
         2_f64 => 8_f64,
        -2_f64 => 8_f64,
      }.each do |v, want|
        it "reports #{want} for a [#{v}, #{v}] vector" do
          Vec2[v, v].length_squared.should equiv(want)
        end
      end
    end

    describe "#length" do
      {
          0_f64 => 0_f64,
          1_f64 => 1.414213562373_f64,
          2_f64 => 2.828427124746_f64,
         -2_f64 => 2.828427124746_f64,
        2.5_f64 => 3.535533905933_f64,
      }.each do |v, want|
        it "reports #{want} for a [#{v}, #{v}] vector" do
          Vec2[v, v].length.should equiv(want)
        end
      end
    end

    describe "#dot" do
      it "returns the dot product of two vectors" do
        Vec2[1, 2].dot(Vec2[3, 4]).should eq 11_f64
      end

      it "is aliased by the &* operator" do
        (Vec2[1, 2] &* Vec2[3, 4]).should eq 11_f64
      end
    end

    describe "#normalize" do
      it "returns a normalized vector" do
        Vec2[5, 8].normalize.length_squared.should equiv(1_f64)
      end
    end

    describe "#normalize!" do
      it "normalizes a vector" do
        Vec2[5, 8].normalize!.length_squared.should equiv(1_f64)
      end
    end

    describe "#multiply" do
      it "does not modify itself" do
        a = Vec2[1, 2]
        b = Vec2[3, 4]
        c = a.multiply(b)
        c.should_not eq a
        c.should_not eq b
      end
    end

    describe "#dup " do
      it "returns a separate instance of a value" do
        x = Vec2.new(1, 2)
        y = x.dup.zero!
        x.should_not eq y
      end
    end

    describe "#to_a" do
      it "returns an array" do
        Vec2[1, 2].to_a.should eq [1_f64, 2_f64]
      end
    end

    describe "#zero!" do
      it "modifies the receiver" do
        x = Vec2.new(1, 2)
        y = x.zero!
        x.should eq y
      end
    end

    describe "#to_s" do
      v = Vec2[1, 2]
      want = "<1.0 2.0>"

      it "returns a string of the form <x y>" do
        v.to_s.should eq want
      end

      it "writes its string value to an IO" do
        v = Vec2[1, 2]
        buf = IO::Memory.new
        v.to_s(buf)
        buf.to_s.should eq want
      end
    end

    describe "swizzle methods" do
      it "two components returns a swizzled Vec2" do
        Vec2[1, 2].xx.should eq Vec2[1, 1]
        Vec2[1, 2].yy.should eq Vec2[2, 2]
      end

      it "three components returns a swizzled Vec3" do
        Vec2[1, 2].xyx.should eq Vec3[1, 2, 1]
        Vec2[1, 2].yxy.should eq Vec3[2, 1, 2]
      end

      it "four components returns a swizzled Vec4" do
        Vec2[1, 2].xyxy.should eq Vec4[1, 2, 1, 2]
        Vec2[1, 2].yyyy.should eq Vec4[2, 2, 2, 2]
      end
    end
  end
end
