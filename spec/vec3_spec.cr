require "./spec_helper"

module Snow
  describe Vec3 do
    describe "#cross" do
      it "should return the cross product of two vectors" do
        r = Vec3[4, 5, 6]
        l = Vec3[1, 2, 3]
        r.cross(l).should eq Vec3[3, 6, 3]
        (r % l).should eq Vec3[3, 6, 3]
      end
    end

    describe "#cross!" do
      it "should set the receiver to the cross product of two vectors" do
        r = Vec3[4, 5, 6]
        l = Vec3[1, 2, 3]
        r.cross!(l)
        r.should eq Vec3[3, 6, 3]
      end
    end
  end
end
