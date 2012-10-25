require 'nokogiri'

class Kekka < Hash
  def self.parse string_or_io
    document = Nokogiri.parse string_or_io
    result = Kekka.new

    result[:boats] = boats_from document
    result[:events] = events_from document
    result
  end

  def self.boats_from document
    Hash[
      document.css( 'boat' ).map do |one_boat_node|
        [one_boat_node['boatid'], self.hash_from_node( one_boat_node )]
      end
    ]
  end

  def self.events_from document
    key_value_pairs = document.css( 'event' ).map do |one_event_node|
      attributes_hash = self.hash_from_node( one_event_node )
      attributes_hash[:races] = self.races_from one_event_node
      [one_event_node['eventid'], attributes_hash]
    end

    Hash[key_value_pairs]
  end

  def self.races_from event_node
    key_value_pairs = event_node.css( 'race' ).map do |one_race_node|
      [one_race_node['raceid'], self.hash_from_node( one_race_node )]
    end
    Hash[key_value_pairs]
  end

  private

  def self.hash_from_node one_node
    attrs = one_node.attributes
    key_value_pairs = attrs.map do |key,nokogiri_attribute|
      [key, nokogiri_attribute.value]
    end
    Hash[key_value_pairs]
  end
end
