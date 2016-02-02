

require 'rack'
require 'json'
require 'nokogiri'
require 'pry'

class Ear
  attr_reader :left, :right, :tags
  def initialize(string, tags = [])
    @left, @right = string.split(' ')
    @tags = tags
  end
end

class Mouth
  attr_reader :mouth, :tags
  def initialize(string, tags = [])
    @mouth = string
    @tags = tags
  end
end

class Eye
  attr_reader :left, :right, :tags
  def initialize(string, tags = [])
    @tags = tags
    chars = string.chars
    chars.delete_at(string.length / 2)
    @left, @right = chars
    @tags = tags
  end
end

class ElementCreator
  def self.create(path)
    html = Nokogiri::HTML(File.open(path), nil, Encoding::UTF_8.to_s)
    html.css('select').zip([Mouth, Eye, Ear]).map {|node, _class| map_children(node, _class)}
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
  def initialize(mouths, eyes, ears)
    @ears, @mouths, @eyes = ears, mouths, eyes
  end


  def make_smily(tag = nil)
    ears = find_part(@ears, tag)
    eyes = find_part(@eyes, tag)
    mouth = find_part(@mouths, tag)
    "#{ears.left}#{eyes.left}#{mouth.mouth}#{eyes.right}#{ears.right}"
  end

  def find_part(parts, tag)
    parts.find_all {|part| part.tags.include?(tag)}.sample || parts.sample
  end

  def tags
    (@ears.map {|part| part.tags}.flatten + @eyes.map {|part| part.tags}.flatten + @mouths.map {|part| part.tags}.flatten).uniq
  end
end



class LennyApp
  LENNY = Lenny.new(*ElementCreator.create('lenny.html'))
  def call(env)
    req = Rack::Request.new(env)
    case req.path
      when '/tags'
        [
            200,
            {'Content-Type' => 'application/json', 'charset' => 'utf-8'},
            [{
                 'response_type' => 'in_channel',
                 'text' => LENNY.tags
             }.to_json]
        ]

      when '/get'
        [
            200,
            {'Content-Type' => 'application/json', 'charset' => 'utf-8'},
            [{
                 'response_type' => 'in_channel',
                 'text' => LENNY.make_smily(req.params[:text] || req.params['text'])
             }.to_json]
        ]
      else
        [404,  {'Content-Type' => 'application/json', 'charset' => 'utf-8'}, [{}.to_json]]
    end
  end
end



