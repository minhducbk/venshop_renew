module MySolr

  def self.connect
    RSolr.connect url: 'http://localhost:8983/solr/item'
  end

  def self.query(keyword)
    solr = MySolr::connect
    solr.get 'select', params: {
      q: "name:*#{keyword}*",
      indent: 'on',
      wt: 'ruby',
      rows: 10_000_000
    }
  end
end
