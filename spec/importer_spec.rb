require File.join(File.dirname(__FILE__), 'spec_helper')
require 'stringio'
require 'builder'
require 'faker'
require 'xdxf_dictionaries'

describe XDXF::Importer do
  def build_xdxf_xml
    @full_name = 'Dictionary'
    @description = 'Test dictionary'
    @lang_from = 'RUS'
    @lang_to = 'RUS'

    @articles = (0..5).collect do |i|
      {:k => Faker::Lorem.words(1), :content => Faker::Lorem.sentence}
    end
    
    # @xml_io = File.open(File.join(File.dirname(__FILE__), 'dict.xdxf'), 'w+') do |io|
    @xml_io = StringIO.new
  
    # Building XML
    @xml = Builder::XmlMarkup.new(:target => @xml_io, :indent => 1)
    @xml.instruct!
    @xml.declare! :DOCTYPE, :xdxf, :SYSTEM, "http://xdxf.sourceforge.net/xdxf_lousy.dtd"
    @xml.xdxf :lang_from => @lang_from, :lang_to => @lang_to, :format => 'visual' do
      @xml.full_name @full_name
      @xml.description @description

      @articles.each do |article|
        @xml.ar do |ar|
          @xml.k article[:k]
          ar << article[:content]
        end
      end

    end

  end

  before(:all) do
    build_xdxf_xml
  end

  it "should correct parse and create dictionary" do
    lambda do
      XDXF::Importer.import(@xml_io)
    end.should change(XDXF::Dictionary, :count).by(1)
    dictionary = XDXF::Dictionary.last
    dictionary.full_name.should == @full_name
    dictionary.description.should == @description
    dictionary.lang_from.should == @lang_from
    dictionary.lang_to.should == @lang_to
  end

end
