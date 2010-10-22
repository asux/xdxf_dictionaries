module XDXF
  # Attributes:
  # * +dictionary_id+ :integer
  # * +the_article+ :text  
  # * +raw_text+ :text
  class Article < XDXF::Model
    validates_presence_of :dictionary_id, :the_article

    belongs_to :dictionary
    has_many   :article_key_article_joins, :dependent => :destroy,  :class_name => "XDXF::ArticleKeyArticleJoin"
    has_many   :article_keys, :through => :article_key_article_joins, :class_name => "XDXF::ArticleKey"
  end
end
