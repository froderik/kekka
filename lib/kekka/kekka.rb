require 'nokogiri'

class Kekka
  def self.parse string_or_io
    document = Nokogiri.parse string_or_io
    boat_nodes = document.css 'boat'
    result = {}
    boats = {}

    boat_nodes.each do |one_boat_node|
      boats[one_boat_node['boatid']] = self.hash_from_node one_boat_node
    end
    result[:boats] = boats
    result
  end

  def self.hash_from_node one_node
    attrs = one_node.attributes
    Hash[attrs.map {|k,v| [k, v.value]}]
  end
end
