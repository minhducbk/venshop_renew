require 'amazon/ecs'
task amazon: :environment do
  Settings.reload!
  Amazon::Ecs.configure do |options|
    options[:AWS_access_key_id] = ENV['aws_access_key_id']
    options[:AWS_secret_key] = ENV['aws_secret_access_key']
    options[:associate_tag] = ENV['associate_tag']
  end

  # To replace default options
  # Amazon::Ecs.options = { ... }

  # To override default options
  res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})

  # Search Amazon Us
  res = Amazon::Ecs.item_search('ruby', :country => 'us')

  # Search all items, default search index: Books
  res = Amazon::Ecs.item_search('ruby', :search_index => 'All')
  puts "Ok here1"
  # res.is_valid_request?
  # res.has_error?
  # res.error                                 # error message
  # res.total_pages
  # res.total_results
  # res.item_page                             # current page no if :item_page option is provided
  if res.blank?
    puts "Blank"
  else
    puts "Present"
    item = res.first_item 
    item_attributes = item.get_element('ItemAttributes')
    puts item_attributes.get('Title')
    puts res.items.size
    puts res.total_pages.size
  end  
  puts "Ok here2"
  categories = Category.all

  categories.each do |category|
    (1..10).each do |page|
      # begin
        puts "Ok here"
        puts category.keyword
        response = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})
        request.item_search(
          query: {
            'SearchIndex' => category.name,
            'Keywords' => category.keyword
            # ,'ResponseGroup' => 'ItemAttributes,Images'
            # ,'ItemPage' => page
          },
          persistent: true
        )
        puts "Ok here1"
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
                descript + "\n" + s
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
      # rescue
      #   puts "Error in donwloading item"
      # end
    end
  end
end
