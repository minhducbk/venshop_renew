class SearchesController < ApplicationController
  include MySolr

  def index
    @key = params[:search][:key_word]
    page = params[:page]
    page ||= 1
    response = MySolr::query(@key, page.to_i)

    list_id_items = response["response"]["docs"].map { |record| record["id"].to_i }
    list_items = list_id_items.present? ? Item.where("id in (#{list_id_items.to_s[1..-2]})") : []
    @list_items= Kaminari.paginate_array(list_items, total_count: response["response"]["numFound"])
                         .page(params[:page]).per(10)
  end

end
