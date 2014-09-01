require 'test_helper'

class Foo < Dun::Land

  data_reader :a

  patch :foo, :bar

  def call
    foo
    bar
  end

end

class Bar < Foo
end

class PatchMethodTest < Test::Unit::TestCase


  def test_patch_method
    assert_raise Dun::Land::MissingPatchedMethodError do
      Bar a: 'a'
    end
  end

end
