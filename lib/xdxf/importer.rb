require 'nokogiri'
require File.join(File.dirname(__FILE__), "..", "node")

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

      raise ImportError, "The object not responds to :read or :string method" if not (io.respond_to?(:read) or io.respond_to?(:string))
      if io.respond_to?(:string)
        xml = io.string
      else
        xml = io.read
      end
      raise ImportError, "Given dictionary is empty" if xml.empty?

      dictionary_record = nil

      doc = Nokogiri.XML(xml)
     
      transaction do 
        Dictionary.benchmark("Dictionary import", Logger::DEBUG, false) do
      
          # Info regarding the dict type
          dictionary_record = Dictionary.create!(
            :full_name => doc.css('full_name').first.content,
            :description => doc.css('description').first.content,
            :lang_from => doc.css('xdxf').first.attributes['lang_from'].value,
            :lang_to   => doc.css('xdxf').first.attributes['lang_to'].value
          )
      
          # Articles
          articles = doc.css('ar')
          articles.each_with_index do |article, index|
            article_progress = "[#{index + 1}/#{articles.size}] (#{(index + 1)*100/articles.size}%)"
            Article.benchmark("#{article_progress} articles import", Logger::DEBUG, false) do
              article_record = dictionary_record.articles.create!(
                :the_article => article.text_or_inner_html,
                :raw_text => article.serialize(serialize_options)
              )
              article_record.article_keys = article.css('k').map do |article_key|
                ArticleKey.find_or_create_by_the_key(
                  :the_key  => article_key.content,
                  :raw_text => article_key.serialize(serialize_options)
                )
              end

              # Logging the article
              article_info = "article keys: #{article_record.article_keys.map{|ak| ak.the_key}.join(",")}"
              Article.logger.info article_info
              puts article_info if options[:verbose]
            end
          end

          # Logging the dictionary
          dictionary_info = "#{dictionary_record.articles.count} of #{articles.size} articles created from dictionary '#{dictionary_record.full_name}'"
          Dictionary.logger.info dictionary_info
          puts dictionary_info if options[:verbose]
        end

      end # transaction
     
      dictionary_record
    end
  end
end
