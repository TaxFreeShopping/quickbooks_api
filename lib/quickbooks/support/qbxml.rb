module Quickbooks::Support::QBXML

  XML_DOCUMENT = Nokogiri::XML::Document
  XML_NODE_SET = Nokogiri::XML::NodeSet
  XML_NODE = Nokogiri::XML::Node
  XML_ELEMENT = Nokogiri::XML::Element
  XML_COMMENT= Nokogiri::XML::Comment
  XML_TEXT = Nokogiri::XML::Text

  COMMENT_START = "<!--"
  COMMENT_END = "-->"
  COMMENT_MATCHER = /\A#{COMMENT_START}.*#{COMMENT_END}\z/


  def is_leaf_node?(xml_obj)
    xml_obj.children.size == 1 && xml_obj.children.first.class == XML_TEXT
  end
  
  def to_attribute_name(obj)
    name = \
      if obj.is_a? Class
        simple_class_name(obj)
      elsif obj.is_a? XML_ELEMENT
        obj.name
      else
        obj.to_s
      end
    inflector.underscore(name)
  end

  # easily convert between CamelCase and under_score
  def inflector
    ActiveSupport::Inflector
  end

  def simple_class_name(klass)
    klass.name.split("::").last
  end

  def qbxml_class_defined?(name)
    get_schema_namespace.constants.include?(name)
  end

  # remove all comment lines and empty nodes
  def cleanup_qbxml(qbxml)
    qbxml = qbxml.split('\n')
    qbxml.map! { |l| l.strip }
    qbxml.reject! { |l| l =~ COMMENT_MATCHER }
    qbxml.join('')
  end

end