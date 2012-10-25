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

    it "should return a jolle" do
      subject[:boats]['7']['boatname'].should == 'jolle'
      subject[:boats]['7']['sailnumber'].should == 'FRA 739'
    end

    it "should return events" do
      subject[:events].size.should == 1
      subject[:events]['9'].should have_keys(['title', 'eventid'])
    end

    it "should return races" do
      subject[:events]['9'][:races].size.should == 10
      subject[:events]['9'][:races].each do |race_id, race_hash|
        race_keys = ['racename', 'racenumber', 'racestartdate', 'racestarttime', 'racestatus', 'raceid']
        race_hash.should have_keys(race_keys)
      end
    end
  end
end
