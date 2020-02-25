require "./spec_helper"

module Snow
  describe Mat4 do
    ident = Mat4.new(
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0,
      0, 0, 0, 1
    )

    zero = Mat4.new(
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0,
      0, 0, 0, 0
    )

    describe ".new" do
      it "should return a zero matrix" do
        Mat4.new.should eq zero
      end

      it "should have the provided elements" do
        m = Mat4.new(
          1, 5, 9, 13,
          2, 6, 10, 14,
          3, 7, 11, 15,
          4, 8, 12, 16,
        )

        # Verify all columns are present.
        m.x.should eq Vec4[1, 2, 3, 4]
        m.y.should eq Vec4[5, 6, 7, 8]
        m.z.should eq Vec4[9, 10, 11, 12]
        m.w.should eq Vec4[13, 14, 15, 16]

        # Verify all rows are present.
        m.rx.should eq Vec4[1, 5, 9, 13]
        m.ry.should eq Vec4[2, 6, 10, 14]
        m.rz.should eq Vec4[3, 7, 11, 15]
        m.rw.should eq Vec4[4, 8, 12, 16]

        # Access column X's components.
        m.xx.should eq 1
        m.xy.should eq 2
        m.xz.should eq 3
        m.xw.should eq 4

        # Access row X's components.
        m.yx.should eq 5
        m.zx.should eq 9
        m.wx.should eq 13
      end
    end

    describe ".transpose" do
      it "should return a transposed matrix" do
        m = Mat4.new(
          1, 2, 3, 4,
          5, 6, 7, 8,
          9, 10, 11, 12,
          13, 14, 15, 16
        )

        want = Mat4.new(
          1, 5, 9, 13,
          2, 6, 10, 14,
          3, 7, 11, 15,
          4, 8, 12, 16,
        )

        m.transpose.should eq want
      end
    end

    describe ".identity" do
      it "should return an identity matrix" do
        Mat4.identity.should eq ident
      end
    end

    describe "#translate" do
      it "should return a translation matrix" do
        m = ident
        m = m.translate(0, 0, 5)
        m.should eq Mat4.new(
          1, 0, 0, 0,
          0, 1, 0, 0,
          0, 0, 1, 5,
          0, 0, 0, 1
        )
      end
    end
  end
end
