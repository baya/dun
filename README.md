# Dun
[![Gem Version](https://badge.fury.io/rb/dun.png)](http://badge.fury.io/rb/dun)

Dun help ruby programers focus on the problem domain directly when programing.

## Example

ref: [7 Patterns to Refactor Fat ActiveRecord Models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/)

### 1. Extract Value Objects

```ruby
  class Rating < Dun::Land
  
	include Comparable

    data_reader :cost

    def call
	  if cost <= 2
		@letter = 'A'
	  elsif cost <= 4
	    @letter = 'B'
	  elsif cost <= 8
	    @letter = 'C'
	  elsif cost <= 16
	    @letter = 'D'
	  else
	    @letter = 'F'
	  end
	end

	def better_than?(other)
	  self > other
	end

	def <=>(other)
	  other.to_s <=> to_s
	end

	def hash
	  @letter.hash
	end

	def eql?(other)
	  to_s == other.to_s
	end

	def to_s
	  @letter.to_s
	end
	
  end
```

### 2. Extract Service Objects

## License
Dun is released under the [MIT License](http://www.opensource.org/licenses/MIT)
