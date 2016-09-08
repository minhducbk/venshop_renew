class SearchesController < ApplicationController
  require 'rubygems'
  require 'rsolr'
  def index
    #solr = RSolr.connect(:read_timeout => 120, :open_timeout => 120)
    solr = RSolr.connect :url => 'http://localhost:8983/solr/item'

    response = solr.get 'select', status: 0, params: {

      q: "name:*#{params[:search][:key_word]}*",
      indent: 'on',
      wt: 'ruby',
      rows: 10000000
    }
    @key = params[:search][:key_word]
    list_items = response["response"]["docs"]
    @list_items= Kaminari.paginate_array(list_items).page(params[:page]).per(10)
  end

end
