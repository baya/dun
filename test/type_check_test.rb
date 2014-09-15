require 'test_helper'

class Foo2 < Dun::Land

  data_reader :a, u: String, c: Array

end

class Bar2 < Foo2
  data_reader a: String
end

class BarBar2 < Foo2
  data_reader :a, :u, :c
end

class DunLandTypeCheckTest < Test::Unit::TestCase

  def test_data_reader_type_check

    assert_raise Dun::Land::TypeCheckError do
      Foo2 u: 1, c: "a"
    end

    assert_raise Dun::Land::TypeCheckError do
      Foo2.new(u: '1', c: "a")
    end

    assert_raise Dun::Land::TypeCheckError do
      Bar2 a: 1, u: '1', c: []
    end

    BarBar2 a:1, u:1, c:1
  end

end
