

require 'rack'
require 'json'
require 'nokogiri'
require 'pry'

class Ear
  attr_reader :left, :right
  def initialize(string, tags = [])
    @left, @right = string.split(' ')
  end
end

class Mouth
  attr_reader :mouth
  def initialize(string, tags = [])
    @mouth = string
  end
end

class Eye
  attr_reader :left, :right
  def initialize(string, tags = [])
    @tags = tags
    chars = string.chars
    chars.delete_at(string.length / 2)
    @left, @right = chars
  end
end

class ElementCreator
  def self.create(path)
    html = Nokogiri::HTML(File.open path)
    html.css('select').zip([Eye, Mouth, Ear]).map {|node, _class| map_children(node, _class)}
  end

  def self.map_children(node, _class)
    node.children.css('option').map do |child|
      attributes =
        if child.attributes['tags']
          child.attributes['tags'].value.gsub(/\s+/, '').split(',')
        else
          []
        end
      _class.new(child.text, attributes)
    end
  end
end






class Lenny
  def initialize(ears, mouths, eyes)
    @ears, @mouths, @eyes = ears, mouths, eyes
  end


  def make_smily(tag = nil)
    ears = @ears.sample
    eyes = @eyes.sample
    mouth = @mouths.sample
    "#{ears.left}#{eyes.left}#{mouth}#{eyes.right}#{ears.right}"
  end
end



class LennyApp
  LENNY = Lenny.new(*ElementCreator.create('lenny.html'))
  def call(env)
    [
        200,
        {'Content-Type' => 'application/json', 'charset' => 'utf-8'},
        [{
            'response_type' => 'in_channel',
            'text' => Lenny.make_smily
        }.to_json]
    ]
  end
end



