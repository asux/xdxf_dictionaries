module XDXF
  # Attributes:
  # * +article_id+ :integer
  # * +article_key_id+ :integer
  class ArticleKeyArticleJoin < XDXF::Model
    belongs_to :article, :class_name => "XDXF::Article"
    belongs_to :article_key, :class_name => "XDXF::ArticleKey"
  end
end
