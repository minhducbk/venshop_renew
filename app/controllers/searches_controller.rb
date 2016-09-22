class SearchesController < ApplicationController
  include MySolr

  def index
    @key = params[:search][:key_word].gsub(/[+\-\&\&||!(){}\[\]^"~*?:\\]/){ |s| "\\" + s }
    page = params[:page]
    page ||= 1
    response = MySolr::query(@key, page.to_i)

    list_items = response["response"]["docs"]
    @list_items= Kaminari.paginate_array(list_items, total_count: response["response"]["numFound"])
                         .page(params[:page]).per(10)
  end

end
