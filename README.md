# Dun(钝)
Dun is a dark color in english, and it is also the pinyin of the chinese character 钝 means not sharp.
Dun help ruby programers focus on the problem domain directly when programing.

## Example

### authenticate

Following is the classic codes about authenticate,

```ruby
  class User < ActiveRecord::Base
	def self.authenticate(email, password)
	  user = find_by_email(email)
	  if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
		user
	  else
		nil
	  end
	end
  end
```

It is ok that we define the class method `authenticate` for the User class to resolve the authenticate problem, but maybe we colud resolve this problem by another new way.

```ruby
  class AuthenticateUser < Dun::Activity
    data_reader :email, :password

    def call
	  user = User.find_by_email(email)
	  if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
 	    user
	  else
	    nil
	  end

	end
	
  end
  
  user = AuthenticateUser email: 'jim@126.com',password: 'secret'
```

Using dun, we could abstract the problem domain to a class, and the class could be inherited, could include module etc and the class name will become a global method, you can execute the method everywhere.

## License
Dun is released under the [MIT License](http://www.opensource.org/licenses/MIT)
