# Excelizer

Excelizer handles Excel files generation for your Rails models with the [Spreadsheet](https://github.com/zdavatz/spreadsheet) gem, using an API similar to the awesome `active_model_serializers`.

## Installation

Add this line to your application's Gemfile:

    gem 'excelizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install excelizer

You will need to add this line to the `config/initializers/mime_types.rb` file:

    Mime::Type.register "application/vnd.ms-excel", :xls

## Usage

You should create a `downloaders` folder inside the `app` folder. You can define a downloader like this

    class UserDownloader < Excelizer::Base
      attr_downloadable :name, :last_name, :email, :birth_date
    end

It's possible to redefine attributes using the `@model` reference 

    class UserDownloader < Excelizer::Base
      attr_downloadable :name, :last_name, :email, :birth_date

      def name
        @model.name.titleize
      end

    end

Or even create new attributes. Keep in mind new attributes will be added at the end of the row, but you can explicitly define the position where they should be. In this example, `phone_number` will go before `birth_date` while `favorite_color` will go after it.

    class UserDownloader < Excelizer::Base
      attr_downloadable :name, :last_name, :email, :phone_number, :birth_date

      def phone_number
        '51' + @model.mobile_phone
      end

      def favorite_color
        @model.favorite_color || 'orange'
      end

    end

Now that we have a downloader, how do we actually use it? If you want to learn how to use it along ActiveAdmin, skip to the next section, if you just want to use the raw data, you can do this:

    raw_data = UserDownloader.new.build_xls

You can optionally pass a collection as a parameter for scoped results:
  
    raw_data = UserDownloader.new.build_xls(User.where(name: 'James'))

## ActiveAdmin

The recommended way to use this gem along ActiveAdmin is using an `action_item` and a `collection_action`. Future releases won't need this ;)

    ActiveAdmin.register User do

      collection_action :download_xls do
        send_data UserDownloader.new.build_xls,
                  type: 'application/vnd.ms-excel',
                  filename: "user_report.xls"
      end

      action_item only: [:index] do
        link_to "Download Excel", download_xls_admin_users_path
      end

    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Acknowledgments

Brought to you by Arturo Puente and the team at [Phantasia](http://www.phantasia.pe/).

[![Phantasia](http://www.phantasia.pe/wp-content/themes/phantasia/images/logo-phantasia-header.png)](http://www.phantasia.pe/)

## Changelog

0.0.8 Safer attribute initialization.  
0.0.7 First release. Codename: Bond

## License

This project is released under the [MIT license](http://opensource.org/licenses/MIT).
