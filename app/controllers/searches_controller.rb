class SearchesController < ApplicationController
  require 'rubygems'
  require 'rsolr'
  include MySolr

  def index
    response = MySolr::query(params[:search][:key_word])

    @key = params[:search][:key_word]
    list_items = response["response"]["docs"]
    @list_items= Kaminari.paginate_array(list_items).page(params[:page]).per(10)
  end

end
