require 'test_helper'

class Foo < Dun::Land

  data_reader u: String, c: Array

end

class Bar < Foo
end

class DunLandTypeCheckTest < Test::Unit::TestCase

  def test_data_reader_type_check
    assert_raise Dun::Land::TypeCheckError do
      Foo u: 1, c: "a"
    end

    assert_raise Dun::Land::TypeCheckError do
      Foo.new(u: '1', c: "a")
    end

  end

end
