require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Kekka do
  describe 'fleet racing' do
    subject { Kekka.parse( open('spec/testdata/fleet-racing-example.xml')) }

    it "should return something" do
      subject.should_not be_nil
    end

    it "should return boats" do
      subject[:boats].size.should == 9
      subject[:boats].each do |boat_id, one_boat_hash|
        one_boat_hash.should have_keys(['boatname', 'sailnumber', 'boatid'])
      end
    end
  end
end
