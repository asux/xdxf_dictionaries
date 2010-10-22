require 'nokogiri'

module XDXF
  # Exception thrown when import error occures
  class ImportError < Exception; end

  # Class implements import from XDXF dictionary
  class Importer < ActiveRecord::Base
    # Import a XDXF file inside the database
    # +serialize_options+ is +Hash+ for +Nokogiri::XML::Node#serialize+ method
    def self.import(io, options = {:verbose => false}, serialize_options = {})
      serialize_options[:save_with] ||= Nokogiri::XML::Node::SaveOptions::FORMAT |
                                        Nokogiri::XML::Node::SaveOptions::NO_DECLARATION |
                                        Nokogiri::XML::Node::SaveOptions::NO_EMPTY_TAGS |
                                        Nokogiri::XML::Node::SaveOptions::AS_HTML

      raise ImportError, "No IO or StringIO object given" if not (io.kind_of?(IO) or io.kind_of?(StringIO))

      xml = io.read
      raise ImportError, "Given dictionary is empty" if xml.empty?

      doc = Nokogiri.XML(xml)
     
      transaction do 
      
        # Info regarding the dict type
        dic = XDXF::Dictionary.create!(
          :full_name => doc.css('full_name').first.content,
          :description => doc.css('description').first.content,
          :lang_from => doc.css('xdxf').first.attributes['lang_from'].value,
          :lang_to   => doc.css('xdxf').first.attributes['lang_to'].value
        )
      
        # Articles
        doc.css('ar').each do |ar|
          (ardb = dic.articles.create!(
            :the_article => ar.content,
            :raw_text => ar.serialize(serialize_options)
          )).article_keys = ar.css('k').map{ |k|
            XDXF::ArticleKey.find_or_create_by_the_key(
              :the_key  => k.content,
              :raw_text => k.serialize(serialize_options)
            )
          }
          puts "<< #{ardb.article_keys.map{|ak| ak.the_key}.join(",")}" if options[:verbose]
        end
                
      end
     
    end
  end
end
