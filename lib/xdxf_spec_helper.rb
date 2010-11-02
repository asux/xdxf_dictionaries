module XDXFSpecHelper
  # Builds XDXF dictionary XML using Builder
  def build_xdxf_xml(dictionary_options = {}, &block)
    dictionary = {
      :full_name => 'Dictionary',
      :description => 'Description of Dictionary',
      :lang_from => 'eng',
      :lang_to => 'eng',
      :target => StringIO.new
    }.merge(dictionary_options)

    # Building XML
    xml = Builder::XmlMarkup.new(:target => dictionary[:target])
    xml.instruct!
    xml.declare! :DOCTYPE, :xdxf, :SYSTEM, "http://xdxf.sourceforge.net/xdxf_lousy.dtd"
    xml.xdxf :lang_from => dictionary[:lang_from], :lang_to => dictionary[:lang_to], :format => 'visual' do
      xml.full_name dictionary[:full_name]
      xml.description dictionary[:description]
      block.call(xml) if block_given?
    end
    dictionary
  end
end
