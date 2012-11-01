require 'nokogiri'

class Kekka < Hash
  def self.parse string_or_io
    document = Nokogiri.parse string_or_io
    result = Kekka.new

    result[:persons] = hash_from document, 'person'
    result[:boats] = hash_from document, 'boat'
    result[:teams] = hash_from document, 'team' do  |team_hash, node|
      team_hash[:crew] = array_from node, 'crew'
    end
    result[:events] = hash_from document, 'event' do |event_hash, node|
      event_hash[:races]     = hash_from node, 'race'
      event_hash[:divisions] = hash_from node, 'division' do |division_hash, node|
        division_hash[:raceresults] = array_from node, 'raceresult' do |hash, node|
          team = result[:teams][hash['teamid']]
          hash['boatid'] = team['boatid']
        end
        division_hash[:seriesresults] = array_from node, 'seriesresult'
        division_hash['scoretype'] ||= 'points'
      end
    end

    result.update_boats_with_class

    result
  end

  def update_boats_with_class
    self[:events].each do |_, event|
      event[:divisions].each do |_, division|
        boat_class = division['title']
        division[:raceresults].each do |one_result|
          team = self[:teams][one_result['teamid']]
          boat = self[:boats][team['boatid']]
          boat['boatclass'] = boat_class
        end
      end
    end
  end

  private

  def self.array_from node, name
    node.css(name).map do |one_node|
      hash = hash_from_node one_node
      yield hash, node if block_given?
      hash
    end
  end

  def self.hash_from node, name
    key_value_pairs = node.css( name ).map do |matching_node|
      attributes_hash = self.hash_from_node( matching_node )
      yield attributes_hash, matching_node if block_given?
      [matching_node["#{name}id"], attributes_hash]
    end
    Hash[key_value_pairs]
  end

  def self.hash_from_node one_node
    attrs = one_node.attributes
    key_value_pairs = attrs.map do |key,nokogiri_attribute|
      [key, nokogiri_attribute.value]
    end
    Hash[key_value_pairs]
  end

end
