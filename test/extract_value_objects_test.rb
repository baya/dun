# ref: http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/
require 'test_helper'

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

class ExtractValueObjectsTest < Test::Unit::TestCase

  def test_rating_to_s
    rating = Rating cost: 1
    assert_equal rating.to_s, 'A'
  end

  def test_better_than
    assert Rating(cost: 2).better_than? Rating(cost: 4)
  end

  def test_rating_eql
    assert Rating(cost: 18).eql? Rating(cost: 17)
    assert Rating(cost: 16).eql?  Rating(cost: 16)
    assert Rating(cost: 2).eql? Rating(cost: 2)
  end
  
end
