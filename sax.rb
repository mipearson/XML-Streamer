#!/usr/bin/ruby

require 'rubygems'
require 'nokogiri'

class SAXHandler < Nokogiri::XML::SAX::Document
  def initialize tag, block
    @node_tree, @node, @start_tag = {}, {}, tag.to_sym
    @depth, @current_tag = 0, []
    @block = block
  end

  def characters string
    return unless @current_tag.include?(@start_tag)
    @node[element_name] = string
  end

  def start_element name, attrs = []
    @current_tag << name.to_sym
  end

  def end_element name
    if @current_tag.last == @start_tag
      @block.call @node
      @node = {}
    end
    @current_tag.pop
  end

  private

  def element_name
    @current_tag.slice(@current_tag.index(@start_tag) + 1, @current_tag.length).join('_')
  end
end

sax_handler = SAXHandler.new('SaleDetail', lambda { |f| puts f.keys })
parser = Nokogiri::XML::SAX::Parser.new(sax_handler)
parser.parse(STDIN)