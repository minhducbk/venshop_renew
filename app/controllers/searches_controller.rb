class SearchesController < ApplicationController
  include MySolr

  def index
    @key = params[:search][:key_word]
    if @key.present?
      page = params[:page]
      page ||= 1
      response = MySolr::query(@key, page.to_i)

      list_id_items = response['response']['docs'].map { |record| record['id'].to_i }
      list_items = list_id_items.present? ? Item.where(id: list_id_items) : []
      @items= Kaminari.paginate_array(list_items, total_count: response['response']['numFound'])
                      .page(params[:page]).per(Settings.entries_per_page)
    else
      @items = Kaminari.paginate_array([]).page(params[:page]).per(Settings.entries_per_page)
    end
  end

end
