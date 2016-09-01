task :vacuum => :environment do
  request = Vacuum.new('US')
  request.configure(
      aws_access_key_id: 'AKIAIAJR65JO6EIPQWTA',
      aws_secret_access_key: '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',
      associate_tag: 'microv'
  )
  request.version = Time.now.in_time_zone('Hanoi').strftime("%Y-%m-%d")

  categories = Category.all
  categories.each do |category|
    item_page = 1
    10.times do
      begin
        response = request.item_search(
          query: {
              'SearchIndex' => category.name,
              'Keywords' => category.keyword,
              'ResponseGroup' => "ItemAttributes,Images",
              'ItemPage' => item_page
          },
          persistent: true
        )
        hashed_products = response.to_h
        hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
          if item['ItemAttributes']['ListPrice'].present?
            price = item['ItemAttributes']['ListPrice']['FormattedPrice'][1..-1].to_f
            stock = item['ItemAttributes']['ListPrice']['Amount'].to_i
          else
            price = Random.new.rand(500.0).to_f.round(2)
            stock = Random.new.rand(500).to_i
          end

          if (item['LargeImage'].present? || item['SmallImage'].present? || item['MediumImage'].present?)
            image_url ||= item['LargeImage']['URL']
            image_url ||= item['MediumImage']['URL']
            image_url ||= item['SmallImage']['URL']
          else
            image_url = "https://www.pantasy.jp/wp-content/uploads/2014/12/no_image3.jpg"
          end

          Item.create(name: item['ItemAttributes']['Title'], price: price,
            amazon_id: item['ASIN'], image_url: image_url,
            stock: stock, category_id: category.id)
        end
      rescue
        break
      end
      item_page += 1
    end
  end
end
