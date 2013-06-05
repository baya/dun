require 'test_helper'

class A < Dun::Activity

  def call
    true
  end
  
end

module B
  class A < Dun::Activity
    def call
      true
    end
  end
end

module B
  class H < Dun::Activity
    def call
      true
    end
  end
end

class C
  class A < Dun::Activity
    def call
      true
    end
  end
end

class C
  class D < Dun::Activity
    def call
      true
    end

    class E < D
      def call
        true
      end
    end
  end
end

class F < C::A
  def call
    true
  end
end

class JustReturnActivitySelf < Dun::Activity
  data_reader :a, :b, :c, :d

  set :name, 'name'

  def call
    self
  end

  def foo
    get_or_set :foo do
      'foo'
    end
  end
  
end

class ActivityTest < Test::Unit::TestCase

  def test_capital_method
    assert A()
    assert F()
    assert B::A()
    assert C::D()
    assert C::A()
    assert C::D()

    assert A     a: 'a', b: 'b'
    assert B::A  a: 'a', b: 'b'
    assert C::D  a: 'a', b: 'b'
    assert C::A  a: 'a', b: 'b'
    assert C::D  a: 'a', b: 'b'

    assert A << {}
    assert B::A << {} 
    assert B::H << {}
    assert C::A << {}
    assert C::D << {}
    assert C::D::E << {}
    assert C::D::E << {a: 'a', b: 'b'}
    
  end

  def test_class
    assert A.new({}).is_a? A
    assert B::A.new({}).is_a? B::A
    assert C::D.new({}).is_a? C::D
    assert C::A.new({}).is_a? C::A
    assert C::D.new({}).is_a? C::D
  end

  def test_data_reader
    activity = JustReturnActivitySelf(a: 'a', b: 'b', c: 'c', d: 'd')
    
    assert_equal activity.a, 'a'
    assert_equal activity.b, 'b'
    assert_equal activity.c, 'c'
    assert_equal activity.d, 'd'

  end

  def test_set
    activity = JustReturnActivitySelf(a: 'a')

    assert_equal activity.name, 'name'
  end

  def test_get_or_set
    activity = JustReturnActivitySelf()

    assert_equal activity.foo, 'foo'
    assert_equal activity.instance_variable_get(:@foo), 'foo'
  end

end
