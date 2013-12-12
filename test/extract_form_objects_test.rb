# ref: http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
require 'test_helper'
require 'ostruct'
require 'virtus'

class Signup < Dun::Land

  include Virtus.model

  attr_reader :user
  attr_reader :company

  attribute :name, String
  attribute :company_name, String
  attribute :email, String

  def persisted?
    false
  end

  def valid?
    email ? true : false
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
    @company = OpenStruct.new(company_name: company_name)
    @user = OpenStruct.new(name: name, email: email)
  end

end

class ExtractFormObjectsTest < Test::Unit::TestCase

  def setup
    @signup = Signup name: 'jim', company_name: 'f5', email: 'jim@126.com'
  end

  def test_extract_form_object
    assert !@signup.persisted?
    assert @signup.save
  end
  
end
