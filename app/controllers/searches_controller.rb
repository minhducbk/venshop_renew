class SearchesController < ApplicationController
  require 'rubygems'
  require 'rsolr'
  def create
    #solr = RSolr.connect(:read_timeout => 120, :open_timeout => 120)
    solr = RSolr.connect :url => 'http://localhost:8983/solr/item'

    response = solr.get 'select', :params => {
      :q=>"name:*#{params[:search][:key]}*"
    }
    @key = params[:search][:key]
    @list_items= response["response"]["docs"]
    byebug
  end

end
