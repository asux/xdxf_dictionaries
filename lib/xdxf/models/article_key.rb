module XDXF
  # Attributes:
  # * +the_key+ :string, :unique
  # * +raw_text+ :text
  class ArticleKey < XDXF::Model
    validates_presence_of :the_key
    validates_uniqueness_of :the_key

    has_many   :article_key_article_joins, :dependent => :destroy, :class_name => "XDXF::ArticleKeyArticleJoin"
    has_many   :articles, :through => :article_key_article_joins, :class_name => "XDXF::Article"
  end
end
