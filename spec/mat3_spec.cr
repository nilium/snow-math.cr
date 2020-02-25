require "./spec_helper"

module Snow
  describe Mat3 do
    ident = Mat3.new(
      1, 0, 0,
      0, 1, 0,
      0, 0, 1,
    )

    zero = Mat3.new(
      0, 0, 0,
      0, 0, 0,
      0, 0, 0
    )

    m1 = Mat3.new(
      1, 2, 3,
      4, 5, 6,
      7, 8, 9,
    )

    describe ".new" do
      it "should return a zero matrix" do
        Mat3.new.should eq zero
      end
    end

    describe ".identity" do
      it "should return an identity matrix" do
        Mat3.identity.should eq ident
      end
    end

    describe ".angle_axis" do
      it "should return an identity matrix for a zero rotation" do
        rm = Mat3.angle_axis(Degrees[0], 0, 1, 0)
        rm.should eq Mat3.identity
      end

      it "should rotate x by 90deg" do
        rm = Mat3.angle_axis(Degrees[90], 1, 0, 0)
        rm.should eq Mat3.new(
          1, 0, 0,
          0, 0, -1,
          0, 1, 0,
        )
      end

      it "should rotate y by 90deg" do
        rm = Mat3.angle_axis(Degrees[90], 0, 1, 0)
        rm.should eq Mat3.new(
          0, 0, 1,
          0, 1, 0,
          -1, 0, 0,
        )
      end

      it "should rotate z by 90deg" do
        rm = Mat3.angle_axis(Degrees[90], 0, 0, 1)
        rm.should eq Mat3.new(
          0, -1, 0,
          1, 0, 0,
          0, 0, 1,
        )
      end

      it "should rotate x by pi/2 radians" do
        rm = Mat3.angle_axis(Radians[Math::PI / 2], 1, 0, 0)
        rm.should eq Mat3.new(
          1, 0, 0,
          0, 0, -1,
          0, 1, 0,
        )
      end

      it "should rotate y by pi/2 radians" do
        rm = Mat3.angle_axis(Radians[Math::PI / 2], 0, 1, 0)
        rm.should eq Mat3.new(
          0, 0, 1,
          0, 1, 0,
          -1, 0, 0,
        )
      end

      it "should rotate z by pi/2 radians" do
        rm = Mat3.angle_axis(Radians[Math::PI / 2], 0, 0, 1)
        rm.should eq Mat3.new(
          0, -1, 0,
          1, 0, 0,
          0, 0, 1,
        )
      end
    end

    describe "#transpose" do
      it "returns a transposed matrix" do
        want = Mat3.new(
          1, 4, 7,
          2, 5, 8,
          3, 6, 9,
        )

        m1.transpose.should eq want
        m1.transpose.should_not eq m1
      end

      it "returns the original matrix if transposed twice" do
        m1.transpose.transpose.should eq m1
      end
    end

    describe "#transpose!" do
      it "transposes the receiver" do
        m2 = m1
        want = Mat3.new(
          1, 4, 7,
          2, 5, 8,
          3, 6, 9,
        )

        m2.transpose!
        m2.should eq want
        m2.should_not eq m1
      end

      it "returns the original matrix if transposed twice" do
        m2 = m1

        m2.transpose!
        m2.should_not eq m1

        m2.transpose!
        m2.should eq m1
      end
    end

    describe "#scale" do
      it "returns a matrix scaled by a vector" do
        want = Mat3.new(
          10, 200, 3000,
          40, 500, 6000,
          70, 800, 9000,
        )
        m1.scale(Vec3[10, 100, 1000]).should eq want
      end
    end

    describe "#scale!" do
      it "scales a matrix by a vector" do
        m2 = m1
        want = Mat3.new(
          10, 200, 3000,
          40, 500, 6000,
          70, 800, 9000,
        )
        m2.scale!(Vec3[10, 100, 1000])
        m2.should eq want
      end
    end

    describe "#multiply[*](Mat3)" do
      it "should return an identity matrix when multiplied with an identity matrix" do
        (m1 * Mat3.identity).should eq m1
      end

      it "should negate all but X if rotating 180d on the X axis" do
        rm = Mat3.angle_axis(Degrees[180], 1, 0, 0)
        want = Mat3.new(
          1, 2, 3,
          -4, -5, -6,
          -7, -8, -9,
        )
        (m1.multiply rm).should eq want
        (m1 * rm).should eq want
      end

      it "should negate all but Z if rotating 180d on the Z axis" do
        rm = Mat3.angle_axis(Degrees[180], 0, 0, 1)
        want = Mat3.new(
          -1, -2, -3,
          -4, -5, -6,
          7, 8, 9,
        )
        (m1.multiply rm).should eq want
        (m1 * rm).should eq want
      end
    end

    describe "#multiply[*](Vec3)" do
      it "should return a rotated vec3 when transforming a vec3" do
        rm = Mat3.angle_axis(Degrees[90], 0, 0, 1)
        v = Vec3[1, 0, 0]
        want = Vec3[0, -1, 0]
        rm.multiply(v).should eq want
        (rm * v).should eq want
      end
    end

    describe "accessors" do
      it "provides rows accessors" do
        m1.rx.should eq Vec3[1, 2, 3]
        m1.ry.should eq Vec3[4, 5, 6]
        m1.rz.should eq Vec3[7, 8, 9]
      end

      it "provides column accessors" do
        m1.cx.should eq Vec3[1, 4, 7]
        m1.cy.should eq Vec3[2, 5, 8]
        m1.cz.should eq Vec3[3, 6, 9]
      end

      it "provides element accessors" do
        m1.xx.should eq 1
        m1.xy.should eq 4
        m1.xz.should eq 7
        m1.yx.should eq 2
        m1.yy.should eq 5
        m1.yz.should eq 8
        m1.zx.should eq 3
        m1.zy.should eq 6
        m1.zz.should eq 9
      end
    end
  end
end
