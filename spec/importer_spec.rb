require File.join(File.dirname(__FILE__), 'spec_helper')
require 'stringio'
require 'builder'
require 'faker'
require 'xdxf_dictionaries'

describe XDXF::Importer do
  include XDXFSpecHelper
  
  before(:each) do
    XDXF::Dictionary.delete_all
  end

  def dictionaries
    @dictionaries ||= Hash.new
  end

  def build_basic_xdxf
    dict = dictionaries[:basic] = build_xdxf_xml
  end

  def build_simple_xdxf
    dict = dictionaries[:simple] = Hash.new
    dict[:full_name] = 'Dictionary'
    dict[:description] = 'Test dictionary'
    dict[:lang_from] = 'RUS'
    dict[:lang_to] = 'RUS'

    dict[:articles] = (0..2).collect do |i|
      {:k => Faker::Lorem.words(1).first, :content => Faker::Lorem.sentence}
    end
    
    result_dict = build_xdxf_xml(dict) do |xml| 
       dict[:articles].each do |article|
        xml.ar do |ar|
          xml.k article[:k]
          ar << article[:content]
        end
      end
    end

    result_dict
  end

  def build_extended_xdxf
    dict = dictionaries[:extended] = Hash.new
    dict[:full_name] = 'Dictionary'
    dict[:description] = 'Test dictionary'
    dict[:lang_from] = 'RUS'
    dict[:lang_to] = 'RUS'

    dict[:articles] = (0..2).collect do |i|
      {:k => "key<nu>#{i}</nu>", :xml => "<tr>tr:#{i}</tr>\n<dtrn><b>#{i})</b> definition #{i}</dtrn>", :content => "key#{i}tr:#{i}#{i}) definition #{i}"}
    end
    
    result_dict = build_xdxf_xml(dict) do |xml| 
       dict[:articles].each do |article|
        xml.ar do |ar|
          xml.k { |k| k << article[:k] }
          ar << article[:xml]
        end
      end
    end

    result_dict
  end

  it "should correct parse and create dictionary" do
    dict = dictionaries[:basic] || build_basic_xdxf
    lambda do
      XDXF::Importer.import(dict[:target])
    end.should change(XDXF::Dictionary, :count).by(1)
    dictionary = XDXF::Dictionary.last
    dictionary.full_name.should == dict[:full_name]
    dictionary.description.should == dict[:description]
    dictionary.lang_from.should == dict[:lang_from]
    dictionary.lang_to.should == dict[:lang_to]
  end
  
  it "should correct parse and create simple articles" do
    dict = dictionaries[:simple] || build_simple_xdxf
    lambda do
      XDXF::Importer.import(dict[:target])
    end.should change(XDXF::Article, :count).by(dict[:articles].count)
    articles = XDXF::Article.all
    articles.each_with_index do |article, i|
      article.the_article.should == dict[:articles][i][:content]
    end
  end

  it "should correct parse and create extended articles" do
    dict = dictionaries[:extended] || build_extended_xdxf
    lambda do
      XDXF::Importer.import(dict[:target])
    end.should change(XDXF::Article, :count).by(dict[:articles].count)
    articles = XDXF::Article.all
    articles.each_with_index do |article, i|
      a = dict[:articles][i]
      article.the_article.should == "<k>#{a[:k]}</k>#{a[:xml]}"
    end
  end

  it "should correct parse and create article keys" do
    dict = dictionaries[:simple] || build_simple_xdxf
    lambda do
      XDXF::Importer.import(dict[:target])
    end.should change(XDXF::ArticleKey, :count).by(dict[:articles].count)
    article_keys = XDXF::ArticleKey.all
    article_keys.each_with_index do |article_key, i|
      article_key.the_key.should == dict[:articles][i][:k]
    end
  end

end
