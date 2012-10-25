require 'nokogiri'

class Kekka < Hash
  def self.parse string_or_io
    document = Nokogiri.parse string_or_io
    result = Kekka.new

    result[:boats] = hash_from document, 'boat'
    result[:teams] = hash_from document, 'team' do  |attributes_hash, node|
      attributes_hash[:crew] = array_from node, 'crew'
    end
    result[:events] = hash_from document, 'event' do |attributes_hash, node|
      attributes_hash[:races]     = hash_from node, 'race'
      attributes_hash[:divisions] = hash_from node, 'division' do |attributes_hash, node|
        attributes_hash[:raceresults] = array_from node, 'raceresult'
      end
    end
    result
  end

  private

  def self.array_from node, name
    node.css(name).map { |one_node| hash_from_node one_node }
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
