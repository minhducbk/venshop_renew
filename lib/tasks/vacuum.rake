task vacuum: :environment do
  Settings.reload!
  request = Vacuum.new('US')
  request.configure(
    aws_access_key_id: ENV['aws_access_key_id'],
    aws_secret_access_key: ENV['aws_secret_access_key'],
    associate_tag: ENV['associate_tag']
  )
  request.version = Time.now.in_time_zone('Hanoi').strftime('%Y-%m-%d')
  categories = Category.all

  categories.each do |category|
    (1..10).each do |page|
      begin
        response = request.item_search(
          query: {
            'SearchIndex' => category.name,
            'Keywords' => category.keyword,
            'ResponseGroup' => 'ItemAttributes,Images',
            'ItemPage' => page
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
          image_url ||= item['LargeImage']['URL'] if item['LargeImage'].present?
          image_url ||= item['MediumImage']['URL'] if item['MediumImage'].present?
          image_url ||= item['SmallImage']['URL'] if item['SmallImage'].present?
          image_url ||= Settings.no_image_link

          description = ''
          if item['ItemAttributes']['Feature'].present?
            if item['ItemAttributes']['Feature'].is_a?(Array)
              description = item['ItemAttributes']['Feature'].inject('') do |descript, s|
                descript + '\n' + s
              end
            else
              description = item['ItemAttributes']['Feature']
            end
          end
          item_exist = Item.find_by(amazon_id: item['ASIN'])
          if item_exist.present?
            item_exist.update_columns(price: price)
            puts "Update price item #{item['ASIN']}"
          else
            item_new = Item.new(
              name: item['ItemAttributes']['Title'],
              price: price,
              amazon_id: item['ASIN'],
              remote_picture_url: image_url,
              stock: stock,
              category_id: category.id,
              description: description
            )
            item_new.save(validate: false)
          end
        end
      rescue
        break
      end
    end
  end
end
