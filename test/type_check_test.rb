require 'test_helper'


class DunLandTypeCheckTest < Test::Unit::TestCase

  class Foo < Dun::Land

    data_reader :a, u: String, c: Array

  end

  class Bar < Foo
    data_reader a: String
  end

  class BarBar < Foo
    data_reader :a, :u, :c
  end


  def test_data_reader_type_check

    assert_raise Dun::Land::TypeCheckError do
      DunLandTypeCheckTest::Foo u: 1, c: "a"
    end

    assert_raise Dun::Land::TypeCheckError do
      Foo.new(u: '1', c: "a")
    end

    assert_raise Dun::Land::TypeCheckError do
      DunLandTypeCheckTest::Bar a: 1, u: '1', c: []
    end

    DunLandTypeCheckTest::BarBar a:1, u:1, c:1
  end

end
