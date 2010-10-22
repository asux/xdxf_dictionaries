module XDXF
  # Attributes:
  # * +lang_from+ :string
  # * +lang_to+ :string
  # * +full_name+ :string
  # * +description+ :text
  class Dictionary < XDXF::Model
    validates_presence_of :lang_from, :lang_to, :full_name
    has_many :articles, :dependent => :destroy, :class_name => "XDXF::Article"
  end
end
