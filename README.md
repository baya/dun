# Dun
[![Gem Version](https://badge.fury.io/rb/dun.png)](http://badge.fury.io/rb/dun)

Dun help ruby programers focus on the problem domain directly when programing.

## How to use dun

### Basic Use

```ruby

  class Add < Dun::Land
    data_reader :a, :b

    def call
	  a + b
	end
	
  end

  Add a: 1, b: 2      # 3
  Add << {a: 1, b: 2} # 3
  Add.new(a: 1, b: 2) # 3
  
```

### data_reader

```ruby
  class Foo < Dun::Land
    data_reader :a, :b
  end
```

`data_reader :a, :b` means that Foo will receive data like '{a: _, b: _}', and `a`, `b` each becomes the attribute of class `Foo`.

### default

```ruby
  class Foo < Dun::Land
    data_reader :a, :b

    default :a, 'a'
	default :b, 'b'
  end
```

`default :a, 'a'` means that if the data a is blank, we will use the default value 'a' of data a.

### set

```ruby
  class Foo < Dun::Land
    data_reader :a, :b

    set :flag, 'red'

  end
```

`set :flag 'red'` will define a instance method :flag returning 'red' for the Foo class.

### get_or_set

```ruby
  class Foo < Dun::Land
    data_reader :a, :b

    def bar
	  get_or_set :bar do
	    complex computing...
	  end
	end

  end
```

`get_or_set :bar, &block` could remember the return value of bar to avoid duplicate computing.

### instance method: default

```ruby
  class Foo < Dun::Land
    data_reader :a, :b
    
	def initialize(data)
	  super
	  default :a, 'a'
	end
    
  end
```

The instance method `default` like the class method `default` is uesed to set default value for input data.

## Features

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

      return self
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

  rating = Rating cost: 8
  
```

### 2. Extract Service Objects

```ruby
  class UserAuthenticator < Dun::Land

	data_reader :user

	def authenticate(password)
	  return false unless user

	  if user.password == password
		user
	  else
		false
	  end
	end

  end

  UserAuthenticator(user: @user).authenticate('password')

```

### 3. Extract Form Objects

```ruby

  class Signup < Dun::Land
	include Virtus

	extend ActiveModel::Naming
	include ActiveModel::Conversion
	include ActiveModel::Validations

	attr_reader :user
	attr_reader :company

	attribute :name, String
	attribute :company_name, String
	attribute :email, String

	validates :email, presence: true
	# … more validations …

	# Forms are never themselves persisted
	def persisted?
	  false
	end

	def save
	  if valid?
		persist!
		true
	  else
		false
	  end
	end

  private

	def persist!
	  @company = Company.create!(name: company_name)
	  @user = @company.users.create!(name: name, email: email)
	end
  end

  @signup = Signup params[:signup]
  @signup.save
  
```

### 4. Extract Query Objects

```ruby
class AbandonedTrialQuery < Dun::Land
  data_reader :relation

  def find_each(&block)
    relation.
      where(plan: nil, invites_count: 0).
      find_each(&block)
  end
end

AbandonedTrialQuery(relation: Account.scoped).find_each do |account|
  account.send_offer_for_support
end

```

### 5. Introduce View Objects

```ruby
class DonutChart < Dun::Land

  data_reader :snapshot

  def cache_key
    snapshot.id.to_s
  end

  def data
    # pull data from @snapshot and turn it into a JSON structure
  end
end
```

### 6. Extract Policy Objects

```ruby
class ActiveUserPolicy < Dun::Land

  data_reader :user
  
  def active?
    user.email_confirmed? &&
    user.last_login_at > 14.days.ago
  end
  
end

ActiveUserPolicy user: @user
```

### 7. Extract Decorators

```ruby
class FacebookCommentNotifier < Dun::Land

  data_reader :comment

  def save
    comment.save && post_to_wall
  end

private

  def post_to_wall
    Facebook.post(title: comment.title, user: comment.author)
  end
end

  FacebookCommentNotifier comment: Comment.new(params[:comment])
  
```

## Process Directly

```ruby

  class SendWarnMail < Dun::Land
    data_reader :address, :content, :title

    def call
	  send_email address, content, title
	end
	
  end

  SendWarnMail address: 'jim@mail.com', content: 'BOM!', title: 'Test'
  
```

## License
Dun is released under the [MIT License](http://www.opensource.org/licenses/MIT)
