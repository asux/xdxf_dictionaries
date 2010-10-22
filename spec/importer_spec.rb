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
      {:k => Faker::Lorem.words(1).first, :content => Faker::Lorem.sentence}
    end
    
    @xml_io = StringIO.new
  
    # Building XML
    @xml = Builder::XmlMarkup.new(:target => @xml_io)
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
    
    # Uncomment if you whant to dump XML to file
    # File.open(File.join(File.dirname(__FILE__), 'dict.xdxf'), 'w+') {|f| f.write(@xml_io.string)}
  end

  before(:all) do
    build_xdxf_xml
  end

  before(:each) do
    XDXF::Dictionary.delete_all
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
  
  it "should correct parse and create articles" do
    lambda do
      XDXF::Importer.import(@xml_io)
    end.should change(XDXF::Article, :count).by(@articles.count)
    articles = XDXF::Article.all
    articles.each_with_index do |article, i|
      article.the_article.should == @articles[i][:content]
    end
  end

  it "should correct parse and create article keys" do
    lambda do
      XDXF::Importer.import(@xml_io)
    end.should change(XDXF::ArticleKey, :count).by(@articles.count)
    article_keys = XDXF::ArticleKey.all
    article_keys.each_with_index do |article_key, i|
      article_key.the_key.should == @articles[i][:k]
    end
  end

end
