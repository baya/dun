require 'test_helper'

class FooSet < Dun::Land

  GG = 'gg'

  set :f, 'foo'
  set :b, -> { const :BlaBla }
  set :g, -> { const :GG }
  set :ggg, GG
  set :c, -> { get_c  }
  set :d, -> {'d'}
  set :s, -> {@s ||= Time.now}
  set :m, ->(*args) { get_m(*args) }

end

class BarSet < FooSet

  BlaBla = 'blabla'

  def get_c
    'c'
  end

  def get_m *args
    args
  end

  def gg
    GG
  end

end

class DunLandSetTest < Test::Unit::TestCase

  def test_set
    foo = FooSet({})
    bar = BarSet({})

    assert_equal foo.f, 'foo'
    assert_equal bar.f, 'foo'
    assert_equal bar.c, 'c'
    assert_equal bar.d, 'd'
    assert_equal bar.b, BarSet::BlaBla
    assert_equal bar.g, BarSet::GG
    assert_equal bar.s, bar.s
    assert_equal bar.m(1,2,3), [1,2,3]
    assert_equal bar.ggg, FooSet::GG
    assert_equal foo.ggg, FooSet::GG

    t0 = Time.now
    10_000_000.times do
      bar.b
    end
    t1 = Time.now

    puts t1 - t0
  end

end
