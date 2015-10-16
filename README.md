# Excelizer

Excelizer handles Excel files generation for your Rails models with the [Spreadsheet](https://github.com/zdavatz/spreadsheet) gem, using an API similar to the awesome `active_model_serializers`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'excelizer'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install excelizer
```

You will need to add this line to the `config/initializers/mime_types.rb` file:

```ruby
Mime::Type.register "application/vnd.ms-excel", :xls
```

## Usage

You should create a `downloaders` folder inside the `app` folder. You can define a downloader like this

```ruby
class UserDownloader < Excelizer::Base
  attribute :name
  attribute :last_name
  attribute :email
  attribute :token
end
```

It's possible to redefine the attributes using the `object` reference

```ruby
class UserDownloader < Excelizer::Base
  attribute :token

  def token
    object.token + rand(100)
  end
end
```

Or even create new attributes by defining them as methods:

```ruby
class UserDownloader < Excelizer::Base
  attribute :full_name

  def full_name
    "#{object.name} #{object.last_name}"
  end
end
```

And you can redefine the object variable by calling the `instance` method:

```ruby
class UserDownloader < Excelizer::Base
  instance :user
  attribute :full_name

  def full_name
    "#{user.name} #{user.last_name}"
  end
end
```

You can redefine the column name by passing the `header` option:

```ruby
class UserDownloader < Excelizer::Base
  attribute :full_name, header: "Nombre Completo"
end
```

Now that we have a downloader, how do we actually use it? If you want to learn how to use it along ActiveAdmin, skip to the next section, if you just want to use the raw output, you can do this:

```ruby
output = UserDownloader.new(User.all).download
```

You can optionally pass a collection as a parameter for scoped results:

```ruby
output = UserDownloader.new(User.where(name: "Jaime")).download
```

## ActiveAdmin

The recommended way to use this gem along ActiveAdmin is using an `action_item` and a `collection_action`. Future releases won't need this ;)

```ruby
ActiveAdmin.register User do
  collection_action :download_xls do
    send_data UserDownloader.new(User.all).download,
              type: 'application/vnd.ms-excel',
              filename: "user_report.xls"
  end

  action_item only: [:index] do
    link_to "Download Excel", download_xls_admin_users_path
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Changelog

- 1.0.0 Introduces brand new API
- 0.2.0 Fix custom header bug
- 0.1.0 Custom header support
- 0.0.9 Adds support for Rails 4
- 0.0.8 Safer attribute initialization
- 0.0.7 First release

## License

This project is released under the [MIT license](http://opensource.org/licenses/MIT).
