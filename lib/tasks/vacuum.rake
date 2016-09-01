
task :vacuum => :environment do
  require 'pry'
  request = Vacuum.new('GB')
  request.configure(
      aws_access_key_id: 'AKIAIAJR65JO6EIPQWTA',
      aws_secret_access_key: '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',
      associate_tag: 'microv'
  )
  request.version = '2016-08-31'
  categories = Category.all
  categories.each do |category|
    number_item_remain = 100
    item_page = 1
    while number_item_remain > 0
      begin
        response = request.item_search(
          query: {
              'SearchIndex' => category.name,
              'Keywords' => category.keyword,
              #'MinimumPrice' => '$1',
              'ResponseGroup' => "ItemAttributes,Images",
              'ItemPage' => item_page
          }
        )
        hashed_products = response.to_h
        #binding.pry
        hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
          if (item['ItemAttributes']['ListPrice'] &&
            (item['LargeImage'] || item['SmallImage'] || item['MediumImage']))
            price = item['ItemAttributes']['ListPrice']['FormattedPrice'][1..-1].to_f
            #binding.pry
            image_url ||= item['LargeImage']['URL']
            image_url ||= item['MediumImage']['URL']
            image_url ||= item['SmallImage']['URL']
            Item.create(name: item['ItemAttributes']['Title'], price: price,
              amazon_id: item['ASIN'], image_url: image_url,
              stock: item['ItemAttributes']['ListPrice']['Amount'].to_i,
              category_id: category.id)
            number_item_remain -= 1
          end
        end

      rescue
        break
      end
      item_page += 1
    end
  end
  # response = request.item_search(
  #   query: {
  #       'SearchIndex' => 'Video',
  #       'Keywords' => 'Video',
  #       'ResponseGroup' => "ItemAttributes,Images"
  #   }
  # )

  # response = request.item_search(
  #   query: {
  #       'SearchIndex' => 'Electronics',
  #       'Keywords' => 'Electronics',
  #       'ResponseGroup' => "ItemAttributes,Images",
  #       'ItemPage' => 9
  #   }
  # )

  # response = request.item_lookup(
  #   query: {
  #     'ItemId' => 'B00I08L864'
  #   }
  # )

  # hashed_products = response.to_h

  # products = []

  # hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
  #   if item['ItemAttributes']['ListPrice'] && item['LargeImage']
  #     product = OpenStruct.new
  #     product.name = item['ItemAttributes']['Title']
  #     product.price = item['ItemAttributes']['ListPrice']['FormattedPrice']
  #     product.image_url = item['LargeImage']['URL']
  #     product.amazon_id = item['ASIN']
  #     products << product
  #   end
  # end

  # puts response.to_h['ItemSearchResponse']['Items']['Item'].collect{|i|
  #   i.keys  if i['ItemAttributes']['ListPrice']
  # }

  # # puts response.to_h['ItemSearchResponse']['Items']['Item'].collect{|i|
  # #   i['ASIN'] if i['ItemAttributes']['ListPrice']
  # # }

  # puts response.to_h['ItemSearchResponse']['Items']['Item'].collect{|i|
  #   i['ItemAttributes']['PackageQuantity'] if i['ItemAttributes']['ListPrice']
  # }


  # puts response.to_h['ItemSearchResponse']['Items']['Item'].collect{|i|
  #   i['ItemAttributes']['ListPrice']['Amount'] if i['ItemAttributes']['ListPrice']
  # }

  # p response.to_h["ItemLookupResponse"]['Items']['Item']['ItemAttributes']['Title']
end
