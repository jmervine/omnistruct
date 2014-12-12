OmniStruct
==========

Helpers for using OpenStruct and/or Struct over Hash

### Usage

Require after or in place of `classy_struct`, `ostruct` and/or `struct`.

```ruby
# good
require 'omnistruct`

# also good
require 'ostruct`
require 'omnistruct`

# bad
require 'omnistruct`
require 'ostruct`
```

> TODO: document the following better

Add's the following methods to `Hash`;

```ruby
# Hash
##

# class methods
Hash.struct_type
Hash.struct_type=

# instance methods
Hash.new.to_struct(type=Hash.struct_type)
```

Add's the following common `Hash` methods to struct types;

```ruby
# All: ClassyStruct / OpenStruct / Struct
##

struct = <struct type>.to_struct( [type] )
merged = <struct type>.merge( Hash.new | <struct type> )
json   = <struct type>.to_json

# ClassyStruct
locked = <classy struct>.lock
locked.class
# => "Struct"

# OpenStruct
OpenStruct.new.merge!( Hash.new | <struct type> )

locked = OpenStruct.new.lock
locked.class
# => "Struct"

# Struct
unlocked = <Struct>.unlock( [type] )
```

### Development

```
bundle install --path .bundle
bundle exec ruby ./test.rb
```
