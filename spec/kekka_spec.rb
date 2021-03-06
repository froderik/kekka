require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Kekka do
  describe 'fleet racing' do
    let(:kekka) { Kekka.parse( open('spec/testdata/fleet-racing-example.xml')) }

    describe 'top level' do
      subject { kekka }

      it "should return something" do
        subject.should_not be_nil
      end

      it "should return boats" do
        subject[:boats].size.should == 9
        subject[:boats].each do |_, one_boat_hash|
          one_boat_hash.should have_keys(['boatname', 'sailnumber', 'boatid'])
        end
      end

      it "should return a jolle" do
        subject[:boats]['7']['boatname'].should == 'jolle'
        subject[:boats]['7']['sailnumber'].should == 'FRA 739'
        subject[:boats]['7']['boatclass'].should == 'Sonar'
      end

      it "should return events" do
        subject[:events].size.should == 1
        subject[:events]['9'].should have_keys(['title', 'eventid'])
      end
    end

    describe 'one event' do
      subject { kekka[:events]['9'] }

      it "should return races" do
        subject[:races].size.should == 10
        subject[:races].each do |_, race_hash|
          race_keys = ['racename', 'racenumber', 'racestartdate', 'racestarttime', 'racestatus', 'raceid']
          race_hash.should have_keys(race_keys)
        end
      end

      it "should return specifics about a race" do
        subject[:races]['383']['racename'     ].should == '6'
        subject[:races]['383']['racenumber'   ].should == '6'
        subject[:races]['383']['racestartdate'].should == '20100128'
        subject[:races]['383']['racestarttime'].should == '111000'
        subject[:races]['383']['racestatus'   ].should == 'Provisional'
      end

      it "should return divisions" do
        subject[:divisions].size.should == 1
        subject[:divisions]['1'].should have_keys ['gender', 'title']
      end
    end

    describe 'one division' do
      subject { kekka[:events]['9'][:divisions]['1'] }

      it "should return specifics about a division" do
        subject['title'].should == 'Sonar'
        subject['gender'].should == 'Open'
        subject['scoretype'].should == 'points'
      end

      it "should return a bunch of race results" do
        subject[:raceresults].size.should == 90
        subject[:raceresults].each do |one_result|
          one_result.should have_keys ['teamid', 'discard', 'raceid', 'racepoints', 'scorecode', 'boatid']
        end
      end

      it "should return a bunch of series results" do
        subject[:seriesresults].size.should == 9
        subject[:seriesresults].each do |one_result|
          one_result.should have_keys ['teamid', 'netpoints', 'rank', 'tied', 'totalpoints']
        end
      end
    end

    describe 'teams' do
      subject { kekka[:teams] }

      it "should return teams" do
        subject.size.should == 9
        subject.each { |_, team| team.should have_keys ['gender', 'noc', 'teamid', 'teamname', 'boatid'] }
      end

      it "should have a crew" do
        subject['GERJK6'][:crew].size.should == 3
        subject['GERJK6'][:crew].each { |one_crew| one_crew.should have_keys ['personid', 'position'] }
      end
    end

    describe 'persons' do
      subject { kekka[:persons] }

      it "should return persons" do
        subject.size.should == 27
        subject.each do |_, one_person|
          one_person.should have_keys ['familyname', 'givenname', 'ifpersonid', 'noc', 'personid']
        end
      end

      it "should return Shimon Ben Yakov" do
        subject['isrsb11']['familyname'].should == 'Ben Yakov'
        subject['isrsb11']['givenname'].should == 'Shimon'
        subject['isrsb11']['ifpersonid'].should == 'isrsb11'
        subject['isrsb11']['noc'].should == 'ISR'
      end
    end
  end
end
