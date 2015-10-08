# CiseauxCsv

**CiseauxCsv** aims to provide tools for working with CSOV CSV files (for "Comma Separated Object Values") files.

CSV files are by definition "flat" and can be painful to describe nested objects or arrays. The CSOV CSV format provides a convention to represent a list of such objects in a flat CSV. 


**Example**:

```csv
title;date;author[name];author[email];tags[];comments[][body];comments[][date]
"First Post !";"2015-01-01";"John Doe";"john@example.com";"ruby|rails|gem";"Great Post! Thx|Not so good...";"2015-01-02|2015-01-03"
"Second Post !";"2015-02-01";"John Doe";"john@example.com";"python|django";"Nobody reads you dude...";"2015-02-02"
```

Describes the following collection (printed in json format here): 

```js
[  
   {  
      "title":"First Post !",
      "date":"2015-01-01",
      "author":{  
         "name":"John Doe",
         "email":"john@example.com"
      },
      "tags":[  
         "ruby",
         "rails",
         "gem"
      ],
      "comments":[  
         {  
            "body":"Great Post! Thx",
            "date":"2015-01-02"
         },
         {  
            "body":"Not so good...",
            "date":"2015-01-03"
         }
      ]
   },
   {  
      "title":"Second Post !",
      "date":"2015-02-01",
      "author":{  
         "name":"John Doe",
         "email":"john@example.com"
      },
      "tags":[  
         "python",
         "django"
      ],
      "comments":[  
         {  
            "body":"Nobody reads you dude...",
            "date":"2015-02-02"
         }
      ]
   }
]
```

This format is heavily inspired by how [Rack](http://rack.github.com/), thus [Rails](http://rubyonrails.org/) or [Sinatra](http://sinatrarb.com/), parse query params. This is what turns params like 

    /ressources?author[name]=bob&tags[]=ruby&tags[]=rails

to a nice params `Hash` in your controllers


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ciseaux_csv'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ciseaux_csv

## Usage

The `CiseauxCsv::CsovFile` class includes the `Enumerable` module, so you can use all methods available for Enumerable: 

* map
* reduce
* select
* find
* to_a
* ...


```ruby
filepath = File.expand_path("test/csov_files/posts.csv", File.dirname(__FILE__))
csov_file = CiseauxCsv::CsovFile.new(filepath)
#=> #<CiseauxCsv::CsovFile:0x007f876feddde0>

csov_file.to_a
#=> [{"title": "First Post !", ...}]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Tricote/ciseaux_csv.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
