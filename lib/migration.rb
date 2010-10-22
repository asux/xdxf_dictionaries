module XDXFDictionaries
  # Migration for cretae tables of XDXF::Dictionary, XDXF::Article, XDXF::ArticleKey and joins
  class CreateXDXFTables < ActiveRecord::Migration
    def self.up
      create_table :dictionaries do |t|
        t.string :full_name
        t.string :lang_from
        t.string :lang_to
        t.text :description
        t.timestamps
      end
  
      create_table :articles do |t|
        t.references :dictionary
        t.text :the_article
        t.text :raw_text
        t.timestamps
      end            

      create_table :article_key_article_joins do |t|
        t.references :article
        t.references :article_key
      end

      create_table :article_keys do |t|
        t.string :the_key
        t.text :raw_text
        t.timestamps
      end
    
      add_index :article_keys, :the_key
    end

    def self.down
      drop_table :dictionaries
      drop_table :articles
      drop_table :article_key_article_joins
      drop_table :article_keys
      drop_table :article_key_herigone_number_joins
  
      remove_index :article_keys, :the_key
    end
  end
end
