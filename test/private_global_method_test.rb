require 'test_helper'

class PrivateFoo < Dun::Land
end


class PrivateGlobalMethodTest < Test::Unit::TestCase

  def test_private_global_method
    assert_raise NoMethodError do
      self.PrivateFoo()
    end
  end

end
