# ref: http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
require 'test_helper'
require 'ostruct'

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

class ExtractServiceObjectsTest < Test::Unit::TestCase

  def setup
    @password = 'secret'
    @wrong_password = 'wrong'
    @user = OpenStruct.new(password: @password)
  end

  def test_extract_service_object
    obj = UserAuthenticator user: @user
    assert obj.authenticate(@password)
    assert !obj.authenticate(@wrong_password)
  end
  
end
