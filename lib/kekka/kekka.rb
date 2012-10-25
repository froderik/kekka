require 'nokogiri'

class Kekka
  def self.parse string_or_io
    document = Nokogiri.parse string_or_io
    boat_nodes = document.css 'boat'
    result = {}
    boats = {}

    boat_nodes.each do |one_boat_node|
      boats[one_boat_node['boatid']] = one_boat_node.attributes
    end
    result[:boats] = boats
    result
  end
end
