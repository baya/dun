require 'test_helper'

class A < Dun::Land

  def call
    true
  end
  
end

module B
  class A < Dun::Land
    def call
      true
    end
  end
end

module B
  class H < Dun::Land
    def call
      true
    end
  end
end

class C
  class A < Dun::Land
    def call
      true
    end
  end
end

class C
  class D < Dun::Land
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

class JustReturnLandSelf < Dun::Land
  data_reader :a, :b, :c, :d, :e, :f, :g

  default :f, 'f'
  default :g, 'g'

  set :name, 'name'

  def initialize(data)
    super
    default(:a, 'a')
    default(:b, 'b')
    default(:c, 'c')
    default(:d, foo)
    default(:e, 'e')
    default(:g, 'gg')
  end

  def call
    self
  end

  def foo
    get_or_set :foo do
      'foo'
    end
  end
  
end

class LandTest < Test::Unit::TestCase

  def test_Capital_method
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
    data = {a: 'a', b: 'b', c: 'c', d: 'd'}
    land = JustReturnLandSelf(data)
    
    assert_equal land.a, 'a'
    assert_equal land.b, 'b'
    assert_equal land.c, 'c'
    assert_equal land.d, 'd'

    data[:a] = 'aa'
    assert_equal land.a, 'a'

  end

  def test_set
    land = JustReturnLandSelf(a: 'a')

    assert_equal land.name, 'name'
  end

  def test_get_or_set
    land = JustReturnLandSelf()

    assert_equal land.foo, 'foo'
    assert_equal land.instance_variable_get(:@foo), 'foo'
  end

  def test_class_default
    land = JustReturnLandSelf(a: 'aa', b: 'bb')
    assert_equal land.f, 'f'
  end

  def test_instance_default
    land = JustReturnLandSelf(a: 'aa', b: 'bb')

    assert_equal land.a, 'aa'
    assert_equal land.b, 'bb'
    assert_equal land.c, 'c'
    assert_equal land.d, 'foo'
    assert_equal land.e, 'e'
  end

  def test_instance_default_over_class_default
    land = JustReturnLandSelf(a: 'aa', b: 'bb')
    assert_equal land.g, 'g'
  end

end
