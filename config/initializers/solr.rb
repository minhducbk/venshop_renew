module MySolr
  require 'rubygems'
  require 'rsolr'

  def self.connect
    RSolr.connect url: 'http://localhost:8983/solr/item'
  end

  def self.query(keyword, page)
    solr = MySolr::connect
    keyword = keyword.gsub(/[+\-\&\&||!(){}\[\]^"~*?:\\]/){ |s| "\\" + s }
    solr.get 'select', params: {
      q: "name:*#{keyword}*",
      indent: 'on',
      wt: 'ruby',
      start: (page - 1)*10,
      rows: 10
    }
  end
end
